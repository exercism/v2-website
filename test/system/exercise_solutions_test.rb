require 'application_system_test_case'

class ExerciseSolutionsTest < ApplicationSystemTestCase
  test "shows exercise solutions ordered by number of reactions" do
    exercise = create(:exercise)
    solution1 = create(:solution,
                       num_reactions: 2,
                       exercise: exercise,
                       published_at: Time.current)
    solution2 = create(:solution,
                       num_reactions: 1,
                       exercise: exercise,
                       published_at: Time.current)
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
