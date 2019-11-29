require 'test_helper'

module Research
  class UserExperimentsControllerTest < ActionDispatch::IntegrationTest
    test "copes with double clicks" do
      user = create :user, :onboarded, joined_research_at: 2.days.ago
      experiment = create :research_experiment

      sign_in!(user)

      # Check that the controller is idempotent
      2.times do
        post research_user_experiments_url(experiment_id: experiment.to_param)
        assert_redirected_to research_user_experiment_url(id: experiment.to_param)
        assert_equal 1, UserExperiment.where(
          user: user,
          experiment: experiment
        ).count
      end
    end
  end
end
