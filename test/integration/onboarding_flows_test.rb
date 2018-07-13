require 'test_helper'

class OnboardingFlowsTest < ActionDispatch::IntegrationTest
  test "password log in respects page you were on after onboarding" do
    password = "foobar"
    user = create :user, password: password, accepted_terms_at: nil
    user.confirm

    Track.any_instance.stubs(repo: repo_mock)
    track = create :track
    get track_path(track)
    assert_response :success

    post user_session_path, params: {user: {email: user.email, password: password}}

    # Follow the jumps to my track
    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!
    assert_redirected_to my_track_path(track)
    follow_redirect!

    # This should redirect to onboarding.
    assert_redirected_to onboarding_path
    assert_response :redirect
    follow_redirect! # We redirect back to show then onwards

    # Fill out the form
    patch onboarding_path
    follow_redirect!

    # Then we should go through loops again
    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!
    assert_redirected_to my_track_path(track)
  end
end

