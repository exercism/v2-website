class AddMentorSelectionIdx2 < ActiveRecord::Migration[5.2]
  def change
    add_index :solutions, [:num_mentors, :track_in_independent_mode, :created_at, :exercise_id], name: "mentor_selection_idx_2"
  end
end
