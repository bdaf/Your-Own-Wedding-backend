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

ActiveRecord::Schema[7.1].define(version: 2024_01_24_032141) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addition_attribiute_names", force: :cascade do |t|
    t.bigint "organizer_id", null: false
    t.string "name", null: false
    t.string "default_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_addition_attribiute_names_on_organizer_id"
  end

  create_table "addition_attribiutes", force: :cascade do |t|
    t.bigint "guest_id", null: false
    t.bigint "addition_attribiute_name_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addition_attribiute_name_id"], name: "index_addition_attribiutes_on_addition_attribiute_name_id"
    t.index ["guest_id"], name: "index_addition_attribiutes_on_guest_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "guests", force: :cascade do |t|
    t.bigint "organizer_id", null: false
    t.string "name"
    t.string "surname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_guests_on_organizer_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["event_id"], name: "index_notes_on_event_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "provider_id", null: false
    t.text "addition_contact_data"
    t.integer "category", default: 0, null: false
    t.float "prize", default: 0.0, null: false
    t.index ["provider_id"], name: "index_offers_on_provider_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.datetime "celebration_date", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_organizers_on_user_id", unique: true
  end

  create_table "providers", force: :cascade do |t|
    t.string "phone_number"
    t.string "address"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_providers_on_user_id", unique: true
  end

  create_table "task_months", force: :cascade do |t|
    t.bigint "organizer_id", null: false
    t.integer "month_number", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_task_months_on_organizer_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "task_month_id", null: false
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_month_id"], name: "index_tasks_on_task_month_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addition_attribiute_names", "organizers"
  add_foreign_key "addition_attribiutes", "addition_attribiute_names"
  add_foreign_key "addition_attribiutes", "guests"
  add_foreign_key "events", "users"
  add_foreign_key "guests", "organizers"
  add_foreign_key "notes", "events"
  add_foreign_key "offers", "providers"
  add_foreign_key "organizers", "users"
  add_foreign_key "providers", "users"
  add_foreign_key "task_months", "organizers"
  add_foreign_key "tasks", "task_months"
end
