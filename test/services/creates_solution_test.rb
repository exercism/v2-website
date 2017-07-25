require 'test_helper'

class CreatesSolutionTest < ActiveSupport::TestCase
  test "creates with correct git sha" do

    user = create :user
    exercise = create :exercise
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)

    solution = CreatesSolution.create!(user, exercise)

    assert solution.persisted?
    assert_equal exercise, solution.exercise
    assert_equal user, solution.user
    assert_equal exercise.slug, solution.git_slug

    assert_equal solution.git_sha, git_sha
  end
end
