require 'test_helper'

class CreatesSolutionTest < ActiveSupport::TestCase
  test "creates with correct git sha" do
    Timecop.freeze do

      user = create :user
      exercise = create :exercise
      git_sha = SecureRandom.uuid
      Git::ExercismRepo.stubs(current_head: git_sha)

      solution = CreatesSolution.create!(user, exercise)

      assert solution.persisted?
      assert_equal exercise, solution.exercise
      assert_equal user, solution.user
      assert_equal exercise.slug, solution.git_slug
      assert_equal solution.created_at.to_i, Time.now.to_i
      assert_equal solution.updated_at.to_i, Time.now.to_i
      assert_equal solution.last_updated_by_user_at.to_i, Time.now.to_i

      assert_equal solution.git_sha, git_sha
    end
  end

  test "copes with duplicates" do
    git_sha = SecureRandom.uuid
    Git::ExercismRepo.stubs(current_head: git_sha)

    solution = create :solution
    assert_equal solution, CreatesSolution.create!(solution.user, solution.exercise)
  end
end
