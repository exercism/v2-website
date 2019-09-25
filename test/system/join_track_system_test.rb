require "application_system_test_case"

class JoinTrackSystemTest < ApplicationSystemTestCase
  test "user joins a track in mentored mode" do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    exercise = create(:exercise,
                      track: track,
                      title: "Hello World",
                      core: true)

    sign_in!(user)
    visit my_track_path(track)
    click_on "Join the Ruby track"

    assert_selector("#modal.my-track-started")
    click_on "Mentored Mode"
    click_on "Continue"

    within(".exercise-wrapper") { assert_text "Hello World" }
    click_link "Hello World"
    assert_selector("h2", text: "Hello World")

    refute UserTrack.last.independent_mode?
  end

  test "user joins a track in independent mode" do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    exercise = create(:exercise,
                      track: track,
                      title: "Hello World",
                      core: true)

    sign_in!(user)
    visit my_track_path(track)
    click_on "Join the Ruby track"

    assert_selector("#modal.my-track-started")
    click_on "Practice Mode"

    within(".widget-side-exercise") { assert_text "Hello World" }
    click_link("Hello World")
    assert_selector("h2", text: "Hello World")

    assert UserTrack.last.independent_mode?
  end
end
