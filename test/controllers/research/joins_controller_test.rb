require 'test_helper'

module Research
  class JoinsControllerTest < ActionDispatch::IntegrationTest
    test "redirects to root when not logged in" do
      get research_join_url

      assert_redirected_to root_path
    end
  end
end
