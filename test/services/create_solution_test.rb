require 'test_helper'

class CreateSolutionTest < ActiveSupport::TestCase
  test "creates with correct git sha" do
    Timecop.freeze do
      user = create :user
      exercise = create :exercise
      create :user_track, user: user, track: exercise.track

      git_sha = SecureRandom.uuid
      Git::ExercismRepo.stubs(current_head: git_sha)

      solution = CreateSolution.(user, exercise)

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
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)

    solution = create :solution
    create :user_track, user: solution.user, track: solution.exercise.track

    assert_equal solution, CreateSolution.(solution.user, solution.exercise)
  end

  test "sets track_in_independent_mode correctly" do
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)

    ruby = create :track
    exercise = create :exercise, track: ruby

    normal_user = create :user
    independent_user = create :user
    neither_user = create :user

    create :user_track, track: ruby, user: normal_user, independent_mode: false
    create :user_track, track: ruby, user: independent_user, independent_mode: true
    create :user_track, track: ruby, user: neither_user, independent_mode: nil

    normal_solution = CreateSolution.(normal_user, exercise)
    neither_solution = CreateSolution.(neither_user, exercise)
    independent_solution = CreateSolution.(independent_user, exercise)

    refute normal_solution.track_in_independent_mode?
    refute neither_solution.track_in_independent_mode?
    assert independent_solution.track_in_independent_mode?
  end
end
