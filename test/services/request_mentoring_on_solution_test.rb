require 'test_helper'

class CancelMentoringRequestForSolutionTest < ActiveSupport::TestCase
  test "sets values correctly" do
    Timecop.freeze do
      create(:user, :system)
      solution = create :solution,
                        mentoring_requested_at: nil,
                        completed_at: Time.now - 1.week,
                        published_at: Time.now - 1.week,
                        approved_by: create(:user),
                        last_updated_by_user_at: Time.now - 1.week,
                        updated_at: Time.now - 1.week

      ut = create :user_track, user: solution.user, track: solution.track
      UserTrack.any_instance.stubs(mentoring_slots_remaining?: true)

      RequestMentoringOnSolution.(solution)

      solution.reload
      assert_equal Time.current.to_i, solution.mentoring_requested_at.to_i
      assert_nil solution.completed_at
      assert_nil solution.published_at
      assert_nil solution.approved_by
      assert_equal Time.now.to_i, solution.last_updated_by_user_at.to_i
      assert_equal Time.now.to_i, solution.updated_at.to_i
    end
  end

  test "doesn't change if mentoring allowance used up" do
    Timecop.freeze do
      create(:user, :system)
      solution = create :solution, mentoring_requested_at: nil
      ut = create :user_track, user: solution.user, track: solution.track
      UserTrack.any_instance.stubs(mentoring_slots_remaining?: false)

      RequestMentoringOnSolution.(solution)
      assert_nil solution.mentoring_requested_at

      UserTrack.any_instance.stubs(mentoring_slots_remaining?: true)
      RequestMentoringOnSolution.(solution)
      assert_equal Time.current.to_i, solution.mentoring_requested_at.to_i
    end
  end

  test "doesn't change if track isn't accepting students" do
    Timecop.freeze do
      create(:user, :system)
      solution = create :solution, mentoring_requested_at: nil
      ut = create :user_track, user: solution.user, track: solution.track
      solution.track.stubs(accepting_new_students?: false)

      RequestMentoringOnSolution.(solution)
      assert_nil solution.mentoring_requested_at

      solution.track.stubs(accepting_new_students?: true)
      RequestMentoringOnSolution.(solution)
      assert_equal Time.current.to_i, solution.mentoring_requested_at.to_i
    end
  end

  test "core non-independent exercises can always be mentored" do
    Timecop.freeze do
      create(:user, :system)
      solution = create :solution, mentoring_requested_at: nil
      ut = create :user_track, user: solution.user, track: solution.track
      UserTrack.any_instance.stubs(mentoring_slots_remaining?: false)

      solution.exercise.update(core: true)
      ut.update(independent_mode: true)
      RequestMentoringOnSolution.(solution)
      assert_nil solution.mentoring_requested_at

      solution.exercise.update(core: false)
      ut.update(independent_mode: false)
      RequestMentoringOnSolution.(solution)
      assert_nil solution.mentoring_requested_at

      solution.exercise.update(core: false)
      ut.update(independent_mode: true)
      RequestMentoringOnSolution.(solution)
      assert_nil solution.mentoring_requested_at

      solution.exercise.update(core: true)
      ut.update(independent_mode: false)
      RequestMentoringOnSolution.(solution)
      assert_equal Time.current.to_i, solution.mentoring_requested_at.to_i
    end
  end

  test "does not create system message if not approved by system" do
    create(:user, :system)
    solution = create :solution, approved_by: create(:user)
    ut = create :user_track, user: solution.user, track: solution.track
    UserTrack.any_instance.stubs(mentoring_slots_remaining?: true)

    CreateSystemDiscussionPost.expects(:call).never

    RequestMentoringOnSolution.(solution)
  end
end
