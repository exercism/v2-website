require "test_helper"

class MentorFeedbackRequestTest < ActiveSupport::TestCase
  test "#status returns :oversubscribed when user track is oversubscribed" do
    user = create(:user)
    track = create(:track, median_wait_time: 2.weeks)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user)
    solution = create(:solution, user: user, exercise: exercise)

    assert_equal :oversubscribed, MentorFeedbackRequest.new(solution).status
  end

  test "#status returns :mentoring_slots_remaining when slots are left" do
    user = create(:user)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user, independent_mode: true)
    solution = create(:solution, user: user, exercise: exercise)

    assert_equal(
      :mentoring_slots_remaining,
      MentorFeedbackRequest.new(solution).status
    )
  end

  test "#status returns :mentoring_slots_used when slots are used" do
    user = create(:user)
    track = create(:track)
    previously_mentored = create(:solution,
                                 mentoring_requested_at: 1.week.ago,
                                user: user)
    create(:iteration, solution: previously_mentored)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user, independent_mode: true)
    solution = create(:solution, user: user, exercise: exercise)

    assert_equal(
      :mentoring_slots_remaining,
      MentorFeedbackRequest.new(solution).status
    )
  end

  test "#status returns :promoted_to_core when side exercise is promoted in mentored mode after legacy" do
    user = create(:user)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user, independent_mode: false)
    solution = create(:solution, user: user, exercise: exercise)

    assert_equal(
      :promoted_to_core,
      MentorFeedbackRequest.new(solution).status
    )
  end

  test "#status returns :mentoring_slots_remaining when side exercise is promoted in mentored mode before legacy" do
    user = create(:user)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user, independent_mode: false)
    solution = create(:solution, user: user, exercise: exercise, last_updated_by_user_at: Exercism::V2_MIGRATED_AT)

    assert_equal(
      :mentoring_slots_remaining,
      MentorFeedbackRequest.new(solution).status
    )
  end
end
