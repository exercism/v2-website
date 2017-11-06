require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'timecop'
require 'minitest/pride'

Rails.application.routes.default_url_options = { :host => "https://v2.exercism.io" }
OmniAuth.config.test_mode = true

class ActionView::TestCase
  include FactoryBot::Syntax::Methods
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in!(user = nil)
    @current_user = user || create(:user)
    @current_user.confirm
    sign_in @current_user
  end

  def assert_correct_page(page)
    assert_includes @response.body, "<div id='#{page}'>"
  end
end
