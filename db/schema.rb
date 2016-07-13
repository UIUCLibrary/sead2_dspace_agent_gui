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

ActiveRecord::Schema.define(version: 20160708204106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aggregated_resources", force: :cascade do |t|
    t.string   "uploaded_by"
    t.string   "is_version_of"
    t.string   "title"
    t.string   "size"
    t.string   "similar_to"
    t.string   "label"
    t.string   "identifier"
    t.string   "sha512"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "research_object_id"
    t.string   "mime_type"
  end

  add_index "aggregated_resources", ["research_object_id"], name: "index_aggregated_resources_on_research_object_id", using: :btree

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

  create_table "research_objects", force: :cascade do |t|
    t.string  "identifier"
    t.string  "ore_url"
    t.string  "uploaded_by"
    t.string  "is_version_of"
    t.string  "title"
    t.string  "topic"
    t.string  "similar_to"
    t.string  "creator"
    t.text    "abstract"
    t.date    "publication_date"
    t.string  "publishing_project"
    t.integer "deposit_id"
  end

  add_index "research_objects", ["deposit_id"], name: "index_research_objects_on_deposit_id", using: :btree

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

  add_foreign_key "aggregated_resources", "research_objects"
  add_foreign_key "research_objects", "deposits"
  add_foreign_key "statuses", "deposits"
end
