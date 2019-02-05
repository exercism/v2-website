require 'test_helper'

class UserTracksControllerTest < ActionDispatch::IntegrationTest
  test "#create starts track and redirects" do
    sign_in!
    track = create :track

    post my_user_tracks_url(track_id: track)

    assert UserTrack.where(track: track, user: @current_user).exists?
    assert_redirected_to my_track_path(track)
  end

  test "#create silently ignores duplicate user_track" do
    sign_in!
    track = create :track
    create :user_track, user: @current_user, track: track

    post my_user_tracks_url(track_id: track)

    assert_equal 1, UserTrack.where(track: track, user: @current_user).size
    assert_redirected_to my_track_path(track)
  end

  test "#set_independent_mode sets the track to independent_mode" do
    sign_in!
    track = create :track
    user_track = create :user_track, user: @current_user, track: track

    SwitchTrackToIndependentMode.expects(:call).with(@current_user, track)
    patch set_independent_mode_my_user_track_url(user_track)
  end

  test "#set_mentored_mode sets the track to independent_mode" do
    sign_in!
    track = create :track
    user_track = create :user_track, user: @current_user, track: track

    SwitchTrackToMentoredMode.expects(:call).with(@current_user, track)
    patch set_mentored_mode_my_user_track_url(user_track)
  end

  test "#leave removes track and redirects" do
    sign_in!
    user_track = create :user_track, user: @current_user

    delete leave_my_user_track_url(user_track)
    assert_redirected_to my_tracks_path
    refute UserTrack.where(id: user_track.id).exists?
  end

  test "#leave redirects to tracks page if track doesn't exist" do
    sign_in!
    delete leave_my_user_track_url(123)
    assert_redirected_to my_tracks_path
  end
end
