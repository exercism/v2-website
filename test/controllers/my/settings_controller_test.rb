require 'test_helper'

class My::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "reset cli token works" do
    sign_in!
    create :auth_token, user: @current_user
    old_token = @current_user.auth_token

    patch reset_auth_token_my_settings_url
    assert_redirected_to my_settings_path

    # Reset cache
    new_token = User.find(@current_user.id).auth_token
    refute_equal old_token, new_token
  end
end
