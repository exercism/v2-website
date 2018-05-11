class AddDescriptionToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :description, :text
  end
end
