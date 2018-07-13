class AddUniqConstraintForTrackMentors < ActiveRecord::Migration[5.2]
  def change
    add_index :track_mentorships, [:user_id, :track_id], unique: true
  end
end
