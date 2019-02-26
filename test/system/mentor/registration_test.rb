require "application_system_test_case"

class MentorRegistrationTest < ApplicationSystemTestCase
  test "signed in mentor flow works" do
    RestClient.expects(:post)

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

    assert_selector "#mentor-next-solutions-page"

    user.reload
    assert user.is_mentor?
    assert_equal [ruby], user.mentored_tracks
  end

  test "logging in mentor flow works" do
    RestClient.expects(:post)

    password = "foobar"
    user = create :user, password: password
    user.confirm

    ruby = create(:track, title: "Ruby")
    python = create(:track, title: "Python")

    visit become_a_mentor_path
    within("#become-a-mentor-page") {
      click_on "Become a mentor"
    }

    within("form#new_user") {
      fill_in 'Email address', with: user.email
      fill_in 'Password', with: password
      click_on "Log in"
    }

    within("#mentor-registration-page") {
      check "accept_code_of_conduct"
      select_option "Ruby", selector: "#track_id"
      click_on "Become a mentor"
    }

    assert_selector "#mentor-next-solutions-page"

    user.reload
    assert user.is_mentor?
    assert_equal [ruby], user.mentored_tracks
  end
end
