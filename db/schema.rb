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

ActiveRecord::Schema[7.1].define(version: 2023_12_19_093914) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chapters", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "sort_key", null: false
    t.integer "course_id"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "deleted_at", precision: nil
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "deleted_at", precision: nil
  end

  create_table "units", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description"
    t.text "content", null: false
    t.integer "sort_key", null: false
    t.integer "chapter_id"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "deleted_at", precision: nil
  end

  add_foreign_key "chapters", "courses", name: "chapters_course_id_fkey"
  add_foreign_key "units", "chapters", name: "units_chapter_id_fkey"
end
