require 'test_helper'

class Research::UserExperimentTest < ActiveSupport::TestCase
  test "solutions and lang_started" do
    user = create :user
    experiment = create :research_experiment
    user_experiment = create :research_user_experiment, experiment: experiment, user: user

    ruby_exercise_1 = create :exercise, slug: "ruby-1-a"
    ruby_exercise_2 = create :exercise, slug: "ruby-2-a"
    common_lisp_exercise = create :exercise, slug: "common-lisp-1-a"
    csharp_exercise = create :exercise, slug: "csharp-1-a"

    solution1 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_1
    solution2 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_2
    solution3 = create :research_experiment_solution, user: user, experiment: experiment, exercise: common_lisp_exercise

    assert_equal [solution1, solution2, solution3], user_experiment.solutions
    assert_equal [:ruby, :'common-lisp'], user_experiment.languages_started
    assert user_experiment.language_started?(:ruby)
    assert user_experiment.language_started?("ruby")
    assert user_experiment.language_started?(:'common-lisp')
    refute user_experiment.language_started?(:csharp)
    refute user_experiment.language_started?(:prolog)
  end
end
