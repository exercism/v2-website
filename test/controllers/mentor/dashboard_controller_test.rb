require 'test_helper'

class MentorControllerTest < ActionDispatch::IntegrationTest

  test "302 if not signed in" do
    get mentor_dashboard_url
    assert_response 302
  end

  test "401 unless mentor" do
    sign_in!
    get mentor_dashboard_url
    assert_response 401
  end

  test "200 if mentor" do
    user = create :user
    create :mentored_track, user: user

    sign_in!(user)
    get mentor_dashboard_url
    assert_response :success
    assert_correct_page "mentor-dashboard-page"
  end
end

