require "application_system_test_case"

class TrackAlumnusTest < ApplicationSystemTestCase
  test "shows track alumnus banner" do
    track = create(:track)
    alumnus = create(:maintainer, track: track, alumnus: "alumnum")

    visit team_page_path

    assert page.has_content?("Alumnum")
  end
end
