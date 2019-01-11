require "application_system_test_case"

class JoinTrackSystemTest < ApplicationSystemTestCase
  test "user joins a track in mentored mode" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track,
                   title: "Ruby",
                   repo_url: "file://#{Rails.root}/test/fixtures/website-copy")
    exercise = create(:exercise,
                      track: track,
                      title: "Hello World",
                      core: true)

    stub_repo_cache! do
      sign_in!(user)
      visit my_track_path(track)
      click_on "Join the Ruby track"

      assert_selector("#modal.my-track-started")
      click_on "Mentored Mode (Recommended)"
      click_on "Continue"

      within(".exercise-wrapper") { assert_text "Hello World" }
      click_link "Hello World"
      assert_selector("h2", text: "Hello World")
    end

    refute UserTrack.last.independent_mode?
  end

  test "user joins a track in independent mode" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track,
                   title: "Ruby",
                   repo_url: "file://#{Rails.root}/test/fixtures/website-copy")
    exercise = create(:exercise,
                      track: track,
                      title: "Hello World",
                      core: true)

    stub_repo_cache! do
      sign_in!(user)
      visit my_track_path(track)
      click_on "Join the Ruby track"

      assert_selector("#modal.my-track-started")
      click_on "Independent Mode"

      within(".widget-side-exercise") { assert_text "Hello World" }
      click_link("Hello World")
      assert_selector("h2", text: "Hello World")
    end

    assert UserTrack.last.independent_mode?
  end
end
