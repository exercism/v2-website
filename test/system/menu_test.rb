require "application_system_test_case"

class MenuTest < ApplicationSystemTestCase
  test "mentor button changes depending on whether user is mentor" do
    sign_in!

    visit root_path
    find('header.logged-in .misc-menu').hover
    assert_selector "header.logged-in a", text: "Become a mentor"
    refute_selector "header.logged-in a", text: "Mentor dashboard"

    create :track_mentorship, user: @current_user

    visit root_path
    find('header.logged-in .misc-menu').hover
    refute_selector "header.logged-in a", text: "Become a mentor"
    assert_selector "header.logged-in a", text: "Mentor dashboard"
  end
end
