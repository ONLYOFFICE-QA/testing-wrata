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

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "clients", force: true do |t|
    t.string   "login"
    t.string   "password"
    t.string   "first_name"
    t.string   "second_name"
    t.string   "post"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "project"
  end

  add_index "clients", ["remember_token"], name: "index_clients_on_remember_token"

  create_table "delayed_runs", force: true do |t|
    t.string   "f_type"
    t.datetime "start_time"
    t.string   "name"
    t.string   "method"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.datetime "next_start"
  end

  create_table "histories", force: true do |t|
    t.string   "file"
    t.integer  "server_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "log",          limit: 255
    t.boolean  "analysed",                 default: false
    t.binary   "data"
    t.string   "total_result"
  end

  create_table "servers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comp_name"
    t.string   "_status",        default: "normal"
    t.integer  "book_client_id"
  end

# Could not dump table "sqlite_stat1" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "start_options", force: true do |t|
    t.string  "docs_branch"
    t.string  "teamlab_branch"
    t.string  "shared_branch"
    t.string  "teamlab_api_branch"
    t.string  "portal_type"
    t.string  "portal_region"
    t.text    "start_command"
    t.integer "history_id"
  end

  create_table "strokes", force: true do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "test_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_files", force: true do |t|
    t.string   "name"
    t.integer  "test_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_lists", force: true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "branch"
    t.string   "project"
  end

end
