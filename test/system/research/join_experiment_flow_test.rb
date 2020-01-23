require_relative "./test_case"

module Research
  class JoinExperimentFlowTest < Research::TestCase
    test "user joins an experiment from the experiments page" do
      user = create(:user, :onboarded, joined_research_at: 2.days.ago)
      experiment = create(:research_experiment)

      sign_in!(user)
      visit research_experiments_path
      click_on "Take part"

      assert UserExperiment.where(user: user, experiment: experiment).exists?
    end
  end
end
