require "test_helper"
require "support/selectize_helpers"
require "support/stub_repo_cache"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers
  include SelectizeHelpers
  include StubRepoCache

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  protected

  def sign_in!(user = nil)
    @current_user = user || create(:user)
    @current_user.confirm
    sign_in @current_user
  end
end
