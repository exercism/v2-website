class AddMentoringIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :solutions, %i{exercise_id approved_by_id completed_at mentoring_requested_at num_mentors id}, name: "mentor_selection_idx_3"
  end
end
