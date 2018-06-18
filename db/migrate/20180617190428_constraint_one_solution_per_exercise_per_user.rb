class ConstraintOneSolutionPerExercisePerUser < ActiveRecord::Migration[5.1]
  def change
    add_index :solutions, [:exercise_id, :user_id], unique: true
  end
end
