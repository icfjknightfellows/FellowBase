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

ActiveRecord::Schema.define(version: 20170209142412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "digital_assets", force: :cascade do |t|
    t.string   "digital_asset_id"
    t.text     "asset"
    t.text     "headline"
    t.string   "genre"
    t.string   "publication"
    t.string   "event_id"
    t.integer  "item_id"
    t.string   "_type"
    t.bigint   "creation_unixtime"
    t.bigint   "last_update_unixtime"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "event_id"
    t.text     "description"
    t.text     "project_ids",     default: [],              array: true
    t.string   "user_ids",        default: [],              array: true
    t.text     "partner_ids",     default: [],              array: true
    t.text     "impact_type_ids", default: [],              array: true
    t.text     "media",           default: [],              array: true
    t.text     "topics",          default: [],              array: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "project_id"
    t.string   "name"
    t.text     "user_ids",    default: [],              array: true
    t.text     "partner_ids", default: [],              array: true
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "ref_impact_types", force: :cascade do |t|
    t.string   "ref_impact_type_id"
    t.text     "name"
    t.string   "genre"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "ref_partners", force: :cascade do |t|
    t.string   "ref_partner_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "trackable_metrics", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "asset_id"
    t.string   "genre"
    t.string   "metric_type"
    t.integer  "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.string   "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
