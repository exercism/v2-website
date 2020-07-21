class AddShowIntroducingResearchModal < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :show_introducing_research_modal, :boolean, default: true, null: false
  end
end
