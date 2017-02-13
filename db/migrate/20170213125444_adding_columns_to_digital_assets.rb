class AddingColumnsToDigitalAssets < ActiveRecord::Migration[5.0]

  def up
    add_column :digital_assets, :last_requested_unixtime, :bigint
    add_column :digital_assets, :custom_errors, :text
    add_column :digital_assets, :tracked, :boolean
  end

  def down
    remove_column :digital_assets, :last_requested_unixtime
    remove_column :digital_assets, :custom_errors
    remove_column :digital_assets, :tracked
  end

end
