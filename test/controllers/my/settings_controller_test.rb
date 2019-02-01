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

  test "allows comments and updates existing" do
    sign_in!
    @current_user.update(default_allow_comments: nil)
    solution = create :solution, user: @current_user, published_at: Time.current, allow_comments: false

    patch set_default_allow_comments_my_settings_path(allow_comments: true, update_solutions: true)

    assert @current_user.reload.default_allow_comments
    assert solution.reload.allow_comments
  end

  test "allows comments but does not update existing" do
    sign_in!
    @current_user.update(default_allow_comments: nil)
    solution = create :solution, user: @current_user, published_at: Time.current, allow_comments: false

    patch set_default_allow_comments_my_settings_path(allow_comments: true)

    assert @current_user.reload.default_allow_comments
    refute solution.reload.allow_comments
  end
end
