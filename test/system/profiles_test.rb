require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  test "user uploads profile image" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    profile = create(:profile, user: user)

    sign_in!(user)
    visit profile_path(profile)
    click_on "Edit public profile"
    attach_file "user_avatar",
      "#{Rails.root}/test/fixtures/test.png",
      make_visible: true
    click_on "Update profile"

    assert_css "img[src*='test.png']"
  end

  test "user uploads profile image with an invalid format" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    profile = create(:profile, user: user)

    sign_in!(user)
    visit profile_path(profile)
    click_on "Edit public profile"
    attach_file "user_avatar",
      "#{Rails.root}/test/fixtures/test.svg",
      make_visible: true
    click_on "Update profile"

    assert_text "We only support PNG, GIF, or JPG pictures."
  end

  test "shows correct contributions count" do
    user = create(:user)
    profile = create(:profile, user: user)
    4.times { create :solution_mentorship, user: user }

    sign_in!(user)
    visit profile_path(profile)

    assert_text "Helped 4 students"
  end
end
