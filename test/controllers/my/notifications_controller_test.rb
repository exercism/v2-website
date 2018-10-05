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

  test "loads all notifications" do
    sign_in!
    notification1 = create :notification, user: @current_user
    notification2 = create :notification, user: @current_user

    get all_my_notifications_url
    assert_equal [notification2, notification1], assigns(:notifications)
  end
end
