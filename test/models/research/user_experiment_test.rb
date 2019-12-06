require 'test_helper'

module Research
  class UserExperimentTest < ActiveSupport::TestCase
    test "solutions" do
      user = create :user
      experiment = create :research_experiment
      user_experiment = create :research_user_experiment, experiment: experiment, user: user

      ruby_exercise_1 = create :exercise, slug: "ruby-a-1"
      ruby_exercise_2 = create :exercise, slug: "ruby-a-2"
      common_lisp_exercise = create :exercise, slug: "common-lisp-a-1"
      csharp_exercise = create :exercise, slug: "csharp-a-1"

      solution1 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_1
      solution2 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_2
      solution3 = create :research_experiment_solution, user: user, experiment: experiment, exercise: common_lisp_exercise

      assert_equal [solution1, solution2, solution3], user_experiment.solutions
    end

    test "lang_started" do
      user = create :user
      experiment = create :research_experiment
      user_experiment = create :research_user_experiment, experiment: experiment, user: user

      ruby_exercise_1 = create :exercise, slug: "ruby-a-1"
      ruby_exercise_2 = create :exercise, slug: "ruby-a-2"
      common_lisp_exercise = create :exercise, slug: "common-lisp-a-1"
      csharp_exercise = create :exercise, slug: "csharp-a-1"

      solution1 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_1
      solution2 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_2
      solution3 = create :research_experiment_solution, user: user, experiment: experiment, exercise: common_lisp_exercise

      assert_equal [:ruby, :'common-lisp'], user_experiment.languages_started
      assert user_experiment.language_started?(:ruby)
      assert user_experiment.language_started?("ruby")
      assert user_experiment.language_started?(:'common-lisp')
      refute user_experiment.language_started?(:csharp)
      refute user_experiment.language_started?(:prolog)
    end

    test "solutions and lang_completed" do
      user = create :user
      experiment = create :research_experiment
      user_experiment = create :research_user_experiment, experiment: experiment, user: user

      ruby_exercise_1 = create :exercise, slug: "ruby-a-1"
      ruby_exercise_2 = create :exercise, slug: "ruby-b-2"
      common_lisp_exercise_1 = create :exercise, slug: "common-lisp-a-1"
      common_lisp_exercise_2 = create :exercise, slug: "common-lisp-b-1"
      csharp_exercise_1 = create :exercise, slug: "csharp-a-1"

      solution1 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_1, finished_at: Time.now
      solution2 = create :research_experiment_solution, user: user, experiment: experiment, exercise: ruby_exercise_2, finished_at: Time.now
      solution3 = create :research_experiment_solution, user: user, experiment: experiment, exercise: common_lisp_exercise_1, finished_at: Time.now
      solution4 = create :research_experiment_solution, user: user, experiment: experiment, exercise: common_lisp_exercise_2
      solution5 = create :research_experiment_solution, user: user, experiment: experiment, exercise: csharp_exercise_1, finished_at: Time.now

      assert_equal [:ruby], user_experiment.languages_completed
      assert user_experiment.language_completed?(:ruby)
      assert user_experiment.language_completed?("ruby")
      refute user_experiment.language_completed?(:'common-lisp')
      refute user_experiment.language_completed?(:csharp)
      refute user_experiment.language_completed?(:prolog)
    end

  end
end
