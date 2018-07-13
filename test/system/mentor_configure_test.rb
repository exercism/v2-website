require "application_system_test_case"

class MentorConfigureTest < ApplicationSystemTestCase
  test "mentor chooses tracks" do
    user = create(:user)
    track = create(:track, title: "Ruby")

    sign_in!(user)
    visit mentor_configure_path
    check "Ruby"
    click_on "Save Settings"

    mentorship = TrackMentorship.last
    assert_equal user, mentorship.user
    assert_equal track, mentorship.track
  end
end
