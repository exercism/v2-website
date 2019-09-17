require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "302 if not signed in" do
    get admin_dashboard_url
    assert_response 302
  end

  test "401 unless admin" do
    sign_in!
    get admin_dashboard_url
    assert_response 401
  end

  test "200 if admin" do
    sign_in!(create :user, :onboarded, admin: true)
    get admin_dashboard_url
    assert_response :success
    assert_correct_page "admin-dashboard-page"
  end
end
