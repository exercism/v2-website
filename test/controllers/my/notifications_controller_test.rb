require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "302 if not signed in" do
    get my_notifications_url
    assert_response 302
  end

  test "200 with notifications" do
    sign_in!
    notification = create :notification, user: @current_user

    get my_notifications_url
    assert_response :success
    assert_correct_page "notifications-page"
  end

  test "200 without notifications" do
    sign_in!
    get my_notifications_url
    assert_response :success
    assert_correct_page "notifications-page"
  end
end
