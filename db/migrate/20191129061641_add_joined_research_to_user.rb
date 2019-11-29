class AddJoinedResearchToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :joined_research, :boolean, null: false, default: false
  end
end
