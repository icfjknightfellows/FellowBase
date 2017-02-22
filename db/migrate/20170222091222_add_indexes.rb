class AddIndexes < ActiveRecord::Migration[5.0]

  def change
    add_index :digital_assets, :digital_asset_id, name: "digital_assets_digital_asset_id"
    add_index :digital_assets, :event_id, name: "digital_assets_event_id"
    add_index :events, :event_id, name: "events_event_id"
    add_index :projects, :project_id, name: "projects_project_id"
    add_index :ref_impact_types, :ref_impact_type_id, name: "ref_impact_types_ref_impact_type_id"
    add_index :ref_partners, :ref_partner_id, name: "ref_partners_ref_partner_id"
    add_index :trackable_metrics, :item_id, name: "trackable_metrics_trackable_metrics_item_id"
    add_index :trackable_metrics, :asset_id, name: "trackable_metrics_trackable_metrics_asset_id"
    add_index :users, :user_id, name: "users_user_id"
  end

end
