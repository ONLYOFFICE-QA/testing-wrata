# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150518095519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace",     limit: 255
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "login",           limit: 255
    t.string   "password",        limit: 255
    t.string   "first_name",      limit: 255
    t.string   "second_name",     limit: 255
    t.string   "post",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: 255
    t.string   "remember_token",  limit: 255
    t.string   "project",         limit: 255
  end

  create_table "delayed_runs", force: :cascade do |t|
    t.string   "f_type",     limit: 255
    t.datetime "start_time"
    t.string   "name",       limit: 255
    t.string   "method",     limit: 255
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location",   limit: 255
    t.datetime "next_start"
  end

  create_table "histories", force: :cascade do |t|
    t.string   "file",         limit: 255
    t.integer  "server_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "log"
    t.boolean  "analysed",                 default: false
    t.binary   "data"
    t.string   "total_result", limit: 255
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "description"
    t.string   "address",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comp_name",      limit: 255
    t.string   "_status",        limit: 255, default: "normal"
    t.integer  "book_client_id"
  end

  create_table "start_options", force: :cascade do |t|
    t.string  "docs_branch",        limit: 255
    t.string  "teamlab_branch",     limit: 255
    t.string  "shared_branch",      limit: 255
    t.string  "teamlab_api_branch", limit: 255
    t.string  "portal_type",        limit: 255
    t.string  "portal_region",      limit: 255
    t.text    "start_command"
    t.integer "history_id"
  end

  create_table "strokes", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "number"
    t.integer  "test_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_files", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "test_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_lists", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "branch",     limit: 255
    t.string   "project",    limit: 255
  end

end
