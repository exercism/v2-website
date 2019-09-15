require 'test_helper'

class Admin::MentorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get Rails.application.routes.url_helpers.admin_mentors_url
    assert_response :success
  end

end
