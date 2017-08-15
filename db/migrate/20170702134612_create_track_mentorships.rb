class CreateTrackMentorships < ActiveRecord::Migration[5.1]
  def change
    create_table :track_mentorships do |t|
      t.bigint :user_id, null: false
      t.bigint :track_id, null: false

      t.string :handle, null: true
      t.string :avatar_url, null: true
      t.string :link_text, null: true
      t.string :link_url, null: true
      t.text :bio, null: true

      t.timestamps
    end

    add_foreign_key :track_mentorships, :users
    add_foreign_key :track_mentorships, :tracks
  end
end
