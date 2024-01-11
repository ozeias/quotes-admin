# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_09_222809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_uuidv7"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authors", id: :uuid, default: -> { "uuid_generate_v7()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "aka", array: true
    t.string "link"
    t.string "bio"
    t.string "description"
    t.boolean "active", default: true, null: false
    t.boolean "verified", default: false, null: false
    t.string "external_id", default: "uuid_generate_v7()", null: false
    t.string "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_authors_on_external_id", unique: true
    t.index ["slug"], name: "index_authors_on_slug", unique: true
    t.index ["source_id"], name: "index_authors_on_source_id", unique: true
  end

  create_table "quotes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "content", null: false
    t.uuid "author_id", null: false
    t.string "tags", default: [], array: true
    t.boolean "active", default: true, null: false
    t.boolean "verified", default: false, null: false
    t.string "external_id", default: "uuid_generate_v7()", null: false
    t.string "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_quotes_on_author_id"
    t.index ["external_id"], name: "index_quotes_on_external_id", unique: true
    t.index ["source_id"], name: "index_quotes_on_source_id", unique: true
    t.index ["tags"], name: "index_quotes_on_tags", using: :gin
  end

  add_foreign_key "quotes", "authors"
end
