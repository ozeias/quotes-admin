class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, id: :uuid, default: 'uuid_generate_v7()' do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :aka,  array: true
      t.string :link
      t.string :bio
      t.string :description
      t.boolean :active, null: false, default: true
      t.boolean :verified, null: false, default: false
      t.string :external_id, null: false, index: { unique: true }, default: 'uuid_generate_v7()'
      t.string :source_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
