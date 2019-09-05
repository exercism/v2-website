require "application_system_test_case"

class SignoutTest < ApplicationSystemTestCase
  test "user signs out" do
    user = create :user, :onboarded
    sign_in! user
    visit my_tracks_path
    find('.misc-menu').hover
    click_on 'Sign out'

    assert_text 'Log in'
  end
end
