require 'test_helper'

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  test "index renders" do
    get track_exercises_path(create(:track))
    assert_response :success
    assert_correct_page "exercises-page"
  end

  test "index only returns active exercises" do
    active_exercise = create :exercise
    create :exercise, track: active_exercise.track, active: false

    get track_exercises_path(active_exercise.track)
    assert_equal [active_exercise], assigns(:exercises)
  end

  test "index 404s with incorrect track id" do
    get track_exercises_path(38383)
    assert_response :missing
  end

  test "show 404s with incorrect track id" do
    get track_exercise_path(38383, create(:exercise))
    assert_response :missing
  end

  test "show 404s with incorrect exercise id" do
    get track_exercise_path(create(:track), 33838)
    assert_response :missing
  end
end

