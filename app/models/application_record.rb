class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # implicit_order_column :created_at
end
