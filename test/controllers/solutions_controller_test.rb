require 'test_helper'

class SolutionsControllerTest < ActionDispatch::IntegrationTest
  test "the truth" do
    sign_in!
    track = create :track
    exercise1 = create :exercise, track: track, core: true
    exercise2 = create :exercise, track: track, core: true
    exercise3 = create :exercise, track: track, core: false
    exercise4 = create :exercise, track: track, core: false
    solution = create :solution, user: @current_user, exercise: exercise1
    solution = create :solution, user: @current_user, exercise: exercise3

    get solution_url(solution)
    assert_response :success
    assert_correct_page "solution-page"
  end
end
