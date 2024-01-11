class Author < ApplicationRecord
  has_many :quotes, dependent: :destroy
end
