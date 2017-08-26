class CreateTrackUpdate < ActiveRecord::Migration[5.1]
  def change
    create_table :track_updates do |t|
      t.belongs_to :track, foreign_key: true, null: false
      t.timestamp :synced_at

      t.timestamps
    end
  end
end
