require 'test_helper'

class RequestMentoringOnSolutionTest < ActiveSupport::TestCase
  test "sets values correctly" do
    Timecop.freeze do
      solution = create :solution,
                        mentoring_requested_at: nil,
                        completed_at: Time.now - 1.week,
                        published_at: Time.now - 1.week,
                        approved_by: create(:user),
                        last_updated_by_user_at: Time.now - 1.week,
                        updated_at: Time.now - 1.week

      ut = create :user_track, user: solution.user, track: solution.track
      UserTrack.any_instance.stubs(mentoring_allowance_used_up?: false)

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
      solution = create :solution, mentoring_requested_at: nil
      ut = create :user_track, user: solution.user, track: solution.track
      UserTrack.any_instance.stubs(mentoring_allowance_used_up?: true)

      RequestMentoringOnSolution.(solution)
      assert_nil solution.mentoring_requested_at

      UserTrack.any_instance.stubs(mentoring_allowance_used_up?: false)
      RequestMentoringOnSolution.(solution)
      assert_equal Time.current.to_i, solution.mentoring_requested_at.to_i
    end
  end
end
