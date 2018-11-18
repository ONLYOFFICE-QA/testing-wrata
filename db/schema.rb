# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_13_122915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "f_type"
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
    t.string "shared_branch", default: "master"
    t.string "teamlab_api_branch", default: "develop"
    t.string "portal_type", default: "info"
    t.string "portal_region", default: "us"
    t.text "start_command"
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

end
