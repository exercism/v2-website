class ChangeJoinedResearchToDatetime < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :joined_research
    add_column :users, :joined_research_at, :datetime
  end
end
