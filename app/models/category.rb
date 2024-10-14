class Category < ApplicationRecord
  def quotes
    @quotes ||= Quote.where(":categories_slug = ANY (categories_slug)", categories_slug: slug)
  end

  def update_quotes_count!
    self.quotes_count = quotes.count
    save!
  end
end
