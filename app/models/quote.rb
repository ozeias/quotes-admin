class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true

  attr_accessor :categories_list
  before_save :create_categories

  private
    def create_categories
      categories_list.each do |category|
        slug = category.parameterize
        record = Category.find_or_initialize_by(slug: slug)
        record.name = category
        record.save
      end
    end
end
