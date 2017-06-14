require 'test_helper'

class UserTracksControllerTest < ActionDispatch::IntegrationTest
  test "#create starts track and redirects" do
    sign_in!
    track = create :track

    post user_tracks_url(track_id: track)

    assert UserTrack.where(track: track, user: @current_user).exists?
    assert_redirected_to track_path(track)
  end

  test "#create silently ignores duplicate user_track" do
    sign_in!
    track = create :track
    create :user_track, user: @current_user, track: track

    post user_tracks_url(track_id: track)

    assert_equal 1, UserTrack.where(track: track, user: @current_user).size
    assert_redirected_to track_path(track)
  end
end
