require 'application_system_test_case'

class TrackSystemTest < ApplicationSystemTestCase
  test "does not show missing maintainers" do
    Track.any_instance.stubs(:about)
    track = create(:track)

    visit track_path(track)
    assert_no_selector ".widget-maintainer"
  end

  test "shows maintainers" do
    Track.any_instance.stubs(:about)
    track = create(:track)
    create :maintainer, track: track, visible: true, name: "Ryan Potts"

    visit track_path(track)
    within(".widget-maintainer") { assert_text "Ryan Potts" }
  end

  test "shows correct exercise count on track page" do
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
end
