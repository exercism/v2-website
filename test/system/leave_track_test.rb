require "application_system_test_case"

class LeaveTrackTest < ApplicationSystemTestCase
  test "user leaves a track" do
    user = create(:user)
    track = create(:track, title: "Ruby")
    create(:user_track,
           user: user,
           track: track,
           independent_mode: false)

    sign_in!(user)
    visit track_path(track)
    click_on "Leave Track"
    click_on "Leave Track"

    within(".other-tracks") { assert_text "Ruby" }
    assert_no_css ".joined-tracks"
  end
end
