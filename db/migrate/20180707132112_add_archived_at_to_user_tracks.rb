class AddArchivedAtToUserTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :user_tracks, :archived_at, :datetime
  end
end
