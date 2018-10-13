require 'application_system_test_case'

class My::PauseUserTracksTest < ApplicationSystemTestCase
  test 'pauses the user track' do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track,
                   title: "Ruby",
                   repo_url: "file://#{Rails.root}/test/fixtures/website-copy")
    user_track = create :user_track, user: user, track: track

    sign_in!(user)
    visit my_track_path(user_track.track)
    click_on "Pause track"
    within("#modal") do
      click_on "Pause track"
    end

    assert user_track.reload.paused?
  end

  test 'unpauses the user track' do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track,
                   title: "Ruby",
                   repo_url: "file://#{Rails.root}/test/fixtures/website-copy")
    user_track = create :user_track, user: user, track: track, paused: true

    sign_in!(user)
    visit my_track_path(user_track.track)
    click_on "Unpause the #{track.title} Track"

    refute user_track.reload.paused?
  end
end
