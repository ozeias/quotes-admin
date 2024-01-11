class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes, id: :uuid do |t|
      t.string :content, null: false
      t.references :author, null: false, foreign_key: true, type: :uuid
      t.string :tags, array: true, default: [], index: { using: 'gin' }
      t.boolean :active, null: false, default: true
      t.boolean :verified, null: false, default: false
      t.string :external_id, null: false, index: { unique: true }, default: 'uuid_generate_v7()'
      t.string :source_id,  null: false, index: { unique: true }

      t.timestamps
    end
  end
end
