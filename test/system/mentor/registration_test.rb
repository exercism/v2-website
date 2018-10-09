require "application_system_test_case"

class MentorRegistrationTest < ApplicationSystemTestCase
  test "mentor chooses tracks" do
    user = create :user
    ruby = create(:track, title: "Ruby")
    python = create(:track, title: "Python")

    sign_in!(user)

    visit become_a_mentor_path
    within("#become-a-mentor-page") {
      click_on "Become a mentor"
    }

    within("#mentor-registration-page") {
      check "accept_code_of_conduct"
      select_option "Ruby", selector: "#track_id"
      click_on "Become a mentor"
    }

    assert_selector "#mentor-dashboard-page"

    user.reload
    assert user.is_mentor?
    assert_equal [ruby], user.mentored_tracks
  end
end
