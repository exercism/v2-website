require "application_system_test_case"

class MenuTest < ApplicationSystemTestCase
  test "mentor dashboard link shows up for mentors" do
    user = create(:user, is_mentor: true)

    sign_in!(user)
    visit root_path
    find('header.logged-in .misc-menu').hover

    refute_selector "header.logged-in a", text: "Become a mentor"
    assert_selector "header.logged-in a", text: "Mentor dashboard"
  end

  test "become a mentor link shows up for people allowed to mentor" do
    user = create(:user, is_mentor: false)
    solution = create(:solution, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit root_path
    find('header.logged-in .misc-menu').hover

    assert_selector "header.logged-in a", text: "Become a mentor"
    refute_selector "header.logged-in a", text: "Mentor dashboard"
  end

  test "become a mentor link hidden for people not allowed to mentor" do
    user = create(:user, is_mentor: false)

    sign_in!(user)
    visit root_path
    find('header.logged-in .misc-menu').hover

    refute_selector "header.logged-in a", text: "Become a mentor"
  end
end
