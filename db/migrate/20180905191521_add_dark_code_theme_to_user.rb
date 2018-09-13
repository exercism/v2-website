class AddDarkCodeThemeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :dark_code_theme, :boolean, null: false, default: false
  end
end
