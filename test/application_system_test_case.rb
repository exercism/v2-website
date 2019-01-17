require "test_helper"
require "support/selectize_helpers"
require "support/stub_repo_cache"
require "support/selenium_helpers"
require "support/bullet_helpers"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers
  include SelectizeHelpers
  include StubRepoCache
  include SeleniumHelpers
  include BulletHelpers

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: SeleniumHelpers.options

  if SeleniumHelpers.default_host.present?
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = '3010'
    Capybara.app_host = "http://#{SeleniumHelpers.default_host}:3010"
  end

  protected

  def sign_in!(user = nil)
    @current_user = user || create(:user, accepted_terms_at: DateTime.new(2000,1,1), accepted_privacy_policy_at: DateTime.new(2000,1,1))
    @current_user.confirm
    sign_in @current_user
  end

  def setup
    if SeleniumHelpers.default_host.present?
      host! "http://#{SeleniumHelpers.default_host}:3010"
    end
    super
  end
end
