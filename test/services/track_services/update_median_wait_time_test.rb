require 'test_helper'

module TrackServices
  class UpdateMedianWaitTimeTest < ActiveSupport::TestCase
    test "updates median wait time for each track" do
      track1 = create(:track)
      create_solution_with_wait_time(wait_time: 2.days, track: track1)
      create_solution_with_wait_time(wait_time: 3.days, track: track1)
      create_solution_with_wait_time(wait_time: 4.days, track: track1)
      create_solution_with_wait_time(wait_time: 4.days, track: track1, core: false)
      track2 = create(:track)
      create_solution_with_wait_time(wait_time: 2.days, track: track2)
      create_solution_with_wait_time(wait_time: 3.days, track: track2)
      create_solution_with_wait_time(wait_time: 4.days, track: track2)
      create_solution_with_wait_time(wait_time: 5.days, track: track2)

      TrackServices::UpdateMedianWaitTime.()

      track1.reload
      assert_equal 3.days, track1.median_wait_time
      track2.reload
      assert_equal 3.5.days, track2.median_wait_time
    end

    private

    def create_solution_with_wait_time(wait_time:, track:, core: true)
      time = Time.current
      exercise = create(:exercise, track: track, core: core)
      solution = create(:solution,
                        exercise: exercise,
                        mentoring_requested_at: time - wait_time,
                        track_in_independent_mode: false,
                        num_mentors: 2)
      iteration = create(:iteration, solution: solution)
      create(:discussion_post, iteration: iteration, created_at: time)
    end
  end
end
