require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  test "index signed out renders" do
    get tracks_url
    assert_response :success
    assert_correct_page "tracks-signed-out-page"
  end

  test "index signed in renders" do
    sign_in!
    get tracks_url
    assert_response :success
    assert_correct_page "tracks-page"
  end

  test "show signed out renders" do
    get track_url(create :track)
    assert_response :success
    assert_correct_page "track-signed-out-page"
  end

  test "show signed in locked renders" do
    sign_in!
    get track_url(create :track)
    assert_response :success
    assert_correct_page "track-locked-page"
  end

  test "show signed in unlocked renders" do
    sign_in!

    track = create :track
    create :user_track, track: track, user: @current_user

    exercise1 = create :exercise, track: track, core: true
    exercise2 = create :exercise, track: track, core: true
    exercise3 = create :exercise, track: track, core: false
    exercise4 = create :exercise, track: track, core: false
    solution1 = create :solution, user: @current_user, exercise: exercise1
    solution2 = create :solution, user: @current_user, exercise: exercise3

    get track_url(track)
    assert_response :success
    assert_correct_page "track-page"
  end
end
