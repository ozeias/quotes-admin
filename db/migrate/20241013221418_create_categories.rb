class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :description
      t.boolean :active, null: false, default: true
      t.integer :quotes_count, null: false, default: 0

      t.timestamps
    end
  end
end
