class PauseUserTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :user_tracks, :paused, :boolean, default: false
    add_column :solution_mentorships, :paused, :boolean, default: false
  end
end
