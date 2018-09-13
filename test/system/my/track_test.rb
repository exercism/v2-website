require 'application_system_test_case'

class My::TrackTest < ApplicationSystemTestCase
  setup do
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    sign_in!(@user)
  end

  test "shows correct exercise count on non joined track page" do
    Track.any_instance.stubs(:about)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:exercise,
           track: track,
           title: "Core Exercise",
           core: true,
           unlocked_by: exercise)
    create(:exercise,
           track: track,
           core: false,
           unlocked_by: exercise)
    create(:exercise,
           track: track,
           core: false,
           unlocked_by: exercise,
           active: false)

    visit track_path(track)
    within(".overview-section") { assert_text /3 [Ee]xercises/ }
    within(".overview-section") { refute_text /4 [Ee]xercises/ }
    within(".exercises-section p") { assert_text /3 [Ee]xercises/ }
    within(".exercises-section p") { refute_text /4 [Ee]xercises/ }
  end

  test "shows correct exercise count on track page" do
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    exercise = create(:exercise, track: track, core: true)
    create(:exercise,
           track: track,
           title: "Core Exercise",
           core: true,
           unlocked_by: exercise)
    create(:exercise,
           track: track,
           core: false,
           unlocked_by: exercise)
    create(:exercise,
           track: track,
           core: false,
           unlocked_by: exercise,
           active: false)
    create(:user_track, track: track, user: @user)

    visit track_path(track)
    within(".progress-section") { assert_text /2 [Cc]ore [Ee]xercises/ }
    within(".progress-section") { refute_text /1\n[Ee]tra [Ee]xercises/ }
  end

  test "shows migration modal for user tracks created before migration" do
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    exercise = create(:exercise, track: track, core: true)

    user_track = create(:user_track, {
      track: track,
      user: @user,
      created_at: Exercism::V2_MIGRATED_AT - 1.day,
      independent_mode: nil
    })

    visit track_path(track)
    within(".main-section") { assert_text "Mentored Mode (Recommended)" }
  end
end
