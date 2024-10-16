class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, id: :uuid, default: 'uuid_generate_v7()' do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :aka,  array: true
      t.string :link
      t.string :bio
      t.string :description
      t.string :gender
      t.string :genres, array: true, default: [], index: { using: 'gin' }
      t.string :birthplace
      t.boolean :proverb, null: false, default: false
      t.boolean :bible, null: false, default: false
      t.boolean :active, null: false, default: true
      t.boolean :verified, null: false, default: false
      t.uuid :external_id, null: false, index: { unique: true }, default: 'uuid_generate_v7()'
      t.string :source_id, index: { unique: true, where: 'source_id IS NOT NULL' }
      t.integer :quotes_count, null: false, default: 0

      t.timestamps
    end
  end
end
