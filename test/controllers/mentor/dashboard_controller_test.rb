require 'test_helper'

class Mentor::DashboardControllerTest < ActionDispatch::IntegrationTest
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
    create :track_mentorship, user: user

    sign_in!(user)
    get mentor_dashboard_url
    assert_response :success
    assert_correct_page "mentor-dashboard-page"
  end

  test "/mentor redirects to dashboard" do
    user = create :user
    create :track_mentorship, user: user

    sign_in!(user)
    get mentor_url
    assert_redirected_to mentor_dashboard_url
  end
end
