require 'application_system_test_case'

class TracksTest < ApplicationSystemTestCase
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
  end
end
