require 'application_system_test_case'

class My::TracksTest < ApplicationSystemTestCase
  setup do
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    sign_in!(@user)
  end

  test "shows correct exercise count on track list" do
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

    visit tracks_path
    assert_text /3 [Ee]xercises/
    refute_text /4 [Ee]xercises/
    assert_text /3 [Ee]xercises/
    refute_text /4 [Ee]xercises/
  end
end
