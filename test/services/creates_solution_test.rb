require 'test_helper'

class CreatesSolutionTest < ActiveSupport::TestCase
  test "creates with correct git sha" do
    user = create :user
    exercise = create :exercise
    git_sha = SecureRandom.uuid

    solution = CreatesSolution.create!(user, exercise)

    assert solution.persisted?
    assert_equal solution.exercise, exercise
    assert_equal solution.user, user

    # TODOGIT
    # assert_equal solution.git_sha, git_sha
  end
end
