class UpdateColumns < ActiveRecord::Migration[5.0]

  def up
    add_column :digital_assets, :post_type, :string, default: ""
  end

  def down
    remove_column :digital_assets, :post_type
  end

end
