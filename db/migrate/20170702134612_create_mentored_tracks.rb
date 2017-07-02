class CreateMentoredTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :mentored_tracks do |t|
      t.bigint :user_id
      t.bigint :track_id

      t.timestamps
    end

    add_foreign_key :mentored_tracks, :users
    add_foreign_key :mentored_tracks, :tracks
  end
end
