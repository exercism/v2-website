require 'application_system_test_case'

class UserSwitchesTrackModeTest < ApplicationSystemTestCase
  test 'switches to mentored mode' do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    user_track = create :user_track, user: user, track: track, independent_mode: true

    sign_in!(user)
    visit my_track_path(user_track.track)
    click_on "Switch to Mentored Mode"
    within("#modal") do
      click_on "Switch to Mentored Mode"
    end

    refute user_track.reload.independent_mode?
  end

  test 'switch to mentor mode is disabled if track is oversubscribed' do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    Track.any_instance.stubs(accepting_new_students?: false)
    user_track = create :user_track, user: user, track: track, independent_mode: true

    sign_in!(user)
    visit my_track_path(user_track.track)
    click_on "Switch to Mentored Mode"
    within("#modal") do
      refute_selector "a", text: "Switch to Mentored Mode"
      click_on "Close"
    end
  end

  test 'switches to independent mode' do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    user_track = create :user_track, user: user, track: track, independent_mode: false

    sign_in!(user)
    visit my_track_path(user_track.track)
    click_on "Switch to Practice Mode"
    within("#modal") do
      click_on "Switch to Practice Mode"
    end

    assert user_track.reload.independent_mode?
  end
end
