require 'test_helper'

module Research
  class CreateSolutionTest < ActiveSupport::TestCase
    test "creates with correct git sha" do
      user = create :user
      experiment = create :research_experiment
      exercise = create :exercise
      git_sha = SecureRandom.uuid
      Git::ExercismRepo.stubs(current_head: git_sha)
      solution = CreateSolution.(user, experiment, exercise)

      assert solution.persisted?
      assert_equal exercise, solution.exercise
      assert_equal user, solution.user
      assert_equal experiment, solution.experiment
      assert_equal exercise.slug, solution.git_slug
      assert_equal solution.git_sha, git_sha
    end

    test "doesn't duplicate solutions" do
      user = create :user
      experiment = create :research_experiment
      exercise = create :exercise
      git_sha = SecureRandom.uuid
      Git::ExercismRepo.stubs(current_head: git_sha)

      solution1 = CreateSolution.(user, experiment, exercise)
      solution2 = CreateSolution.(user, experiment, exercise)
      assert_equal solution1.id, solution2.id
    end
  end
end
