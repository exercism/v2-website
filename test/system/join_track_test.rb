require "application_system_test_case"

class JoinTrackTest < ApplicationSystemTestCase
  test "user rejoins a track" do
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
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      completed_at: Date.new(2016, 12, 25))
    create(:user_track,
           user: user,
           track: track,
           independent_mode: false,
           archived_at: Date.new(2016, 12, 25))

    stub_repo_cache! do
      sign_in!(user)
      visit my_track_path(track)
      click_on "Join the Ruby track"
    end

    within(".exercise-wrapper.completed") { assert_text "Hello World" }
  end
end
