require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  test "index signed in renders" do
    sign_in!
    get my_tracks_url
    assert_response :success
    assert_correct_page "my-tracks-page"
  end

  test "show logged out redirects" do
    Track.any_instance.stubs(repo: repo_mock)
    track = create :track
    get my_track_url(track)
    assert_redirected_to track_url(track)
  end

  test "show locked renders" do
    sign_in!

    Track.any_instance.stubs(repo: repo_mock)
    get my_track_url(create :track)
    assert_response :success
    assert_correct_page "my-track-not-joined-page"
  end

  test "show unlocked renders" do
    Git::ExercismRepo.stubs(pages: [])

    sign_in!

    track = create :track
    create :user_track, track: track, user: @current_user

    exercise1 = create :exercise, track: track, core: true
    exercise2 = create :exercise, track: track, core: true
    exercise3 = create :exercise, track: track, core: false
    exercise4 = create :exercise, track: track, core: false
    solution1 = create :solution, user: @current_user, exercise: exercise1
    solution2 = create :solution, user: @current_user, exercise: exercise3

    get my_track_url(track)
    assert_response :success
    assert_correct_page "my-track-page"
  end
end
