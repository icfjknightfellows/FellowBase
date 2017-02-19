class AddSelectedDimensionsToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :selected_dimensions, :text, default: ""
  end

  def down
    remove_column :users, :selected_dimensions
  end
end
