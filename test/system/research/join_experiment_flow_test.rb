require_relative "./test_case"

module Research
  class JoinExperimentFlowTest < Research::TestCase
    test "user joins an experiment from the experiments page" do
      user = create(:user, :onboarded)
      experiment = create(:research_experiment)

      sign_in!(user)
      visit research_experiments_path
      click_on "Participate"

      assert UserExperiment.where(user: user, experiment: experiment).exists?
    end

    test "user joins an experiment from the experiment page" do
      user = create(:user, :onboarded)
      experiment = create(:research_experiment)

      sign_in!(user)
      visit research_experiments_path
      click_on "Learn More"

      click_on "Participate"
      assert UserExperiment.where(user: user, experiment: experiment).exists?
    end
  end
end
