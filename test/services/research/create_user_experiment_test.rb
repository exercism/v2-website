require 'test_helper'

module Research
  class CreateUserExperimentTest < ActiveSupport::TestCase
    test "creates correctly" do
      user = create :user
      experiment = create :research_experiment
      user_experiment = CreateUserExperiment.(user, experiment)

      assert user_experiment.persisted?
      assert_equal user, user_experiment.user
      assert_equal experiment, user_experiment.experiment
    end

    test "doesn't duplicate solutions" do
      user = create :user
      experiment = create :research_experiment

      ue1 = CreateUserExperiment.(user, experiment)
      ue2 = CreateUserExperiment.(user, experiment)
      assert_equal ue1.id, ue2.id
    end
  end
end

