class AddExtraSolutionsIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :solutions, [:num_mentors, :independent_mode, :created_at, :exercise_id], name: "mentor_selection_idx_1"
  end
end
