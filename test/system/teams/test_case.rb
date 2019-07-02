require "application_system_test_case"

class Teams::TestCase < ApplicationSystemTestCase
  setup do
    @original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host
  end

  teardown do
    Capybara.app_host = @original_host
  end
end
