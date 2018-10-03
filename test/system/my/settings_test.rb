require 'application_system_test_case'

class My::SettingsTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    BootstrapUser.(@user)
    sign_in!(@user)
  end

  test "shows CLI token" do
    visit my_settings_path
    assert ".download-code" do
        assert "[value=?]", @user.auth_token
    end
  end

  test "can change password successfully" do
    visit my_settings_path

    assert_selector "#old_password"
    assert_selector "#user_password"
    assert_selector "#user_password_confirmation"

    old_password = FactoryBot.attributes_for(:user)[:password]

    fill_in "Enter your current password", with: old_password
    fill_in "Enter your new password", with: "password"
    fill_in "Confirm your current password", with: "password"

    click_on "Update password"

    assert_selector "#notice", text: "Password updated successfully" 
  end

  test "can change handle successfully" do
    visit my_settings_path

    assert_selector "#user_handle"

    new_handle = SecureRandom.uuid
    fill_in "Enter your new handle", with: new_handle

    click_on "Update handle"

    assert_selector "#notice", text: "Handle updated successfully" 
    @user.reload
    assert_equal @user.handle, new_handle
  end

  test "CLI token field should be readonly" do
    visit my_settings_path

    assert find("input.download-code")["readonly"]
  end
end
