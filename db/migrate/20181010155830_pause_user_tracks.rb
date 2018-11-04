class PauseUserTracks < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_tracks, :archived_at, :paused_at
    add_column :solutions, :paused, :boolean, default: false, null: false
  end
end
