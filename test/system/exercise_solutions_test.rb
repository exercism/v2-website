require 'application_system_test_case'

class ExerciseSolutionsTest < ApplicationSystemTestCase
  test "shows exercise solutions ordered by published_at" do
    exercise = create(:exercise)
    solution1 = create(:solution,
                       exercise: exercise,
                       published_at: Time.current - 1.week)
    solution2 = create(:solution,
                       exercise: exercise,
                       published_at: Time.current - 1.year)
    expected_solutions = [solution1, solution2]

    visit track_exercise_path(exercise.track, exercise)

    actual_solutions = page.
      find_all(".solution").
      map { |solution| solution[:href] }
    0..actual_solutions.length do |i|
      assert_match expected_solutions[i], actual_solutions[i]
    end
  end
end
