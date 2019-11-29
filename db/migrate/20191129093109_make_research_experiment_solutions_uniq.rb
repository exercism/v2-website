class MakeResearchExperimentSolutionsUniq < ActiveRecord::Migration[6.0]
  def change
    add_index :research_experiment_solutions, [:user_id, :experiment_id, :exercise_id], unique: true, name: "research_solutions_uniq"
  end
end
