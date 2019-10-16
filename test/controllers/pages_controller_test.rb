require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "index page" do
    get "/"
    assert_response :success
  end

  test "cli_walkthrough page" do
    get cli_walkthrough_page_path
    assert_response :success
  end

  PagesController::PAGES.each do |(title, page)|
    test "page works signed in: #{page}" do
      user = create(:user)
      sign_in!(user)
      get send("#{page}_page_path")
      assert_response :success
    end
  end

  PagesController::PAGES.each do |(title, page)|
    test "page works signed out: #{page}" do
      get send("#{page}_page_path")
      assert_response :success
    end
  end

  PagesController::LICENCES.each do |(title, licence)|
    test "licence works signed in: #{licence}" do
      user = create(:user)
      sign_in!(user)
      get send("#{licence}_licence_path")
      assert_response :success
    end
  end

  PagesController::LICENCES.each do |(title, licence)|
    test "licence works signed out: #{licence}" do
      get send("#{licence}_licence_path")
      assert_response :success
    end
  end
end
