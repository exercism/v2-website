require 'application_system_test_case'

class My::SettingsPreferencesTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    @user = create(:user, :onboarded)
    BootstrapUser.(@user)
    sign_in!(@user)
  end

  test "can navigate to preferences" do
    visit my_settings_path
    assert page.has_link?(href: edit_my_settings_preferences_path)
    click_on "Preferences"
    assert_current_path edit_my_settings_preferences_path
  end
end
