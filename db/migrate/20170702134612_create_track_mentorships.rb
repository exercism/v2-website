class CreateTrackMentorships < ActiveRecord::Migration[5.1]
  def change
    create_table :track_mentorships do |t|
      t.bigint :user_id
      t.bigint :track_id

      t.timestamps
    end

    add_foreign_key :track_mentorships, :users
    add_foreign_key :track_mentorships, :tracks
  end
end
