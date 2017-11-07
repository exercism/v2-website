class AddIndependentModeToUserTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :user_tracks, :independent_mode, :boolean, null: true
  end
end
