class AddSurveyFieldsToExperimentSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :research_experiment_solutions, :difficulty_rating, :integer, null: true
  end
end
