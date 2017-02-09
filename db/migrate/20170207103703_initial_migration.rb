class InitialMigration < ActiveRecord::Migration[5.0]

  def up
    create_table "events", force: :cascade do |t|
      t.string   "event_id"
      t.text     "description"
      t.text     "project_ids",         default: [],              array: true
      t.string   "user_ids",            default: [],              array: true
      t.text     "partner_ids",         default: [],              array: true
      t.text     "impact_type_ids",     default: [],              array: true
      t.text     "media",               default: [],              array: true
      t.text     "topics",              default: [],              array: true
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end

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
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end

    create_table "projects", force: :cascade do |t|
      t.string   "project_id"
      t.string   "name"
      t.text     "user_ids",            default: [],              array: true
      t.text     "partner_ids",         default: [],              array: true
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end

    create_table "ref_impact_types", force: :cascade do |t|
      t.string   "ref_impact_type_id"
      t.text     "name"
      t.string   "genre"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
    end

    create_table "ref_partners", force: :cascade do |t|
      t.string   "ref_partner_id"
      t.string   "name"
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
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
  end

  def down
    drop_table :events
    drop_table :digital_assets
    drop_table :projects
    drop_table :ref_impact_types
    drop_table :ref_partners
    drop_table :trackable_metrics
  end

end
