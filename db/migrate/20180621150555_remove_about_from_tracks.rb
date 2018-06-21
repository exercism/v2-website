class RemoveAboutFromTracks < ActiveRecord::Migration[5.1]
  def change
    remove_column :tracks, :about
  end
end
