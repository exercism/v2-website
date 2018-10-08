require "application_system_test_case"

class MentorRegistrationTest < ApplicationSystemTestCase
  test "mentor chooses tracks" do
    user = create :user
    ruby = create(:track, title: "Ruby")

    sign_in!(user)

    visit new_mentor_registrations_path
    within("#mentor-registration-page") { click_on "Become a mentor" }

    check "Ruby"
    click_on "Save settings"

    assert_selector "#mentor-dashboard-page"

    user.reload
    assert user.is_mentor?
  end
end
