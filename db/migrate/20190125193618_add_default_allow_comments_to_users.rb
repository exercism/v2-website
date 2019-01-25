class AddDefaultAllowCommentsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :default_allow_comments, :boolean, null: true
  end
end
