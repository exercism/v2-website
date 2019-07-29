class AddFullWidthCodePanesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :full_width_code_panes, :boolean, null: false, default: false
  end
end
