require 'application_system_test_case'

class TrackTest < ApplicationSystemTestCase
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
end
