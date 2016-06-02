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

ActiveRecord::Schema.define(version: 20160527173326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deposits", force: :cascade do |t|
    t.string   "title"
    t.string   "creator"
    t.text     "abstract"
    t.string   "state"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "publication_callback"
    t.text     "license"
    t.string   "rights_holder"
    t.date     "created"
    t.string   "identifier"
    t.string   "ore_url"
  end

  create_table "statuses", force: :cascade do |t|
    t.datetime "date"
    t.string   "reporter"
    t.string   "stage"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "deposit_id"
  end

  add_index "statuses", ["deposit_id"], name: "index_statuses_on_deposit_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "email"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  add_foreign_key "statuses", "deposits"
end
