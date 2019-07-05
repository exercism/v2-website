require 'test_helper'

module ExerciseServices
  class UpdateMedianWaitTimeTest < ActiveSupport::TestCase
    test "updates median wait time for each exercise" do
      exercise1 = create(:exercise)
      create_solution_with_wait_time(wait_time: 2.days, exercise: exercise1)
      create_solution_with_wait_time(wait_time: 3.days, exercise: exercise1)
      create_solution_with_wait_time(wait_time: 4.days, exercise: exercise1)
      exercise2 = create(:exercise)
      create_solution_with_wait_time(wait_time: 2.days, exercise: exercise2)
      create_solution_with_wait_time(wait_time: 3.days, exercise: exercise2)
      create_solution_with_wait_time(wait_time: 4.days, exercise: exercise2)
      create_solution_with_wait_time(wait_time: 5.days, exercise: exercise2)

      ExerciseServices::UpdateMedianWaitTime.()

      exercise1.reload
      assert_equal 3.days, exercise1.median_wait_time
      exercise2.reload
      assert_equal 3.5.days, exercise2.median_wait_time
    end

    private

    def create_solution_with_wait_time(wait_time:, exercise:)
      time = Time.current
      solution = create(:solution,
                        exercise: exercise,
                        mentoring_requested_at: time - wait_time,
                        track_in_independent_mode: false,
                        num_mentors: 1)
      iteration = create(:iteration, solution: solution)
      create(:discussion_post, iteration: iteration, created_at: time)
    end
  end
end
