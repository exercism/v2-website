class AddUrlJoinAllowedToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :url_join_allowed, :boolean, null: false, default: true
  end
end
