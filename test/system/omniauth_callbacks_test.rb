require "application_system_test_case"

class OmniauthCallbacksTest < ApplicationSystemTestCase
  test "raises the correct error on failure" do
    AuthenticateUserFromOmniauth.expects(:call).raises

    visit user_github_omniauth_callback_path
    assert_selector "#alert", text: "Sorry, we could not authenticate you from GitHub. Check the FAQs for for info."
    assert_selector '#alert a[href="/faqs"]', text: "FAQs"
  end
end
