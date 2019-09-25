class AddMayEditChangelogToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :may_edit_changelog, :boolean, default: false, null: false
  end
end
