class AddSurveyToUserExperiments < ActiveRecord::Migration[6.0]
  def change
    add_column :research_user_experiments, :survey, :json
  end
end
