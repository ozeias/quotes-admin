require 'net/http'

class QuotableJob < ApplicationJob
  BASE_URL = 'https://api.quotable.io'

  queue_as :default

  def perform(*args)
    fetch_data_for 'authors'
    fetch_data_for 'quotes'
  end

  private

  def fetch_data_for(data_type)
    page = 1
    total_page = nil

    uri = build_uri(data_type)
    data = fetch_data(uri)
    total_page = data['totalPages']
    process_results(data['results'], data_type)
    page += 1

    while page <= total_page do
      uri = build_uri(data_type, page: page)
      data = fetch_data(uri)
      process_results(data['results'], data_type)
      page += 1
    end
  end

  def create_or_update_author(author)
    record = Author.find_or_initialize_by(source_id: author['_id'])
    record.name = author['name']
    record.slug = author['slug']
    record.aka = author['aka']
    record.link = author['link']
    record.bio = author['bio']
    record.description = author['description']
    record.external_id = UUID7.generate if record.new_record?
    record.save!
  end

  def create_or_update_quote(quote)
    author = Author.find_by(slug: quote['authorSlug'])
    record = Quote.find_or_initialize_by(source_id: quote['_id'])
    record.content = quote['content']
    record.author = author
    record.categories_list = quote['tags']
    record.categories_slug = quote['tags'].map(&:parameterize)
    record.external_id = UUID7.generate if record.new_record?
    record.save!
  end

  def build_uri(content, page: 1, limit: 100)
    url = "#{BASE_URL}/#{content}"
    params = { page: page, limit: limit }
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params)
    uri
  end

  def fetch_data(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end

  def process_results(results, type)
    results.each do |result|
      case type
      when 'authors'
        create_or_update_author(result)
      when 'quotes'
        create_or_update_quote(result)
      end
    end
  end
end
