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

ActiveRecord::Schema.define(version: 2020_12_15_155647) do

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.string "first_name"
    t.string "second_name"
    t.string "post"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest"
    t.string "remember_token"
    t.string "project"
    t.boolean "verified", default: false
    t.string "env_file", default: ""
    t.index ["remember_token"], name: "index_clients_on_remember_token"
  end

  create_table "delayed_runs", id: :serial, force: :cascade do |t|
    t.datetime "start_time"
    t.string "name"
    t.string "method"
    t.integer "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "location"
    t.datetime "next_start"
  end

  create_table "histories", id: :serial, force: :cascade do |t|
    t.string "file"
    t.integer "server_id"
    t.integer "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "log"
    t.binary "data"
    t.string "total_result"
    t.datetime "start_time"
    t.integer "exit_code"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "servers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "comp_name"
    t.string "_status", default: "destroyed"
    t.integer "book_client_id"
    t.datetime "last_activity_date"
    t.boolean "executing_command_now", default: false
    t.boolean "self_destruction", default: true
    t.string "size", default: "1gb"
  end

  create_table "spec_browsers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spec_languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "start_options", id: :serial, force: :cascade do |t|
    t.string "docs_branch", default: "develop"
    t.string "teamlab_branch", default: "master"
    t.string "portal_type", default: "info"
    t.string "portal_region", default: "us"
    t.text "start_command"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "history_id"
    t.string "spec_language", default: "en-us"
    t.string "spec_browser"
  end

  create_table "test_files", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "test_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_lists", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "branch"
    t.string "project"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
