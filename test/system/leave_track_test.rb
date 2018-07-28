require "application_system_test_case"

class LeaveTrackTest < ApplicationSystemTestCase
  test "user leaves a track" do
    Git::ExercismRepo.stubs(pages: [])

    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track, title: "Ruby")
    create(:user_track,
           user: user,
           track: track,
           independent_mode: false)

    sign_in!(user)
    visit track_path(track)
    click_on "Leave Track"
    within("#modal") do
      click_on "Leave Track"
    end

    within(".other-tracks") { assert_text "Ruby" }
    assert_no_css ".joined-tracks"
  end
end
