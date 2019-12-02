require_relative "./test_case"

module Research
  class UserSignsUpToJoinTest < TestCase
    include ActiveJob::TestHelper

    test "user signs up" do
      perform_enqueued_jobs do
        visit new_user_registration_path
        sign_up
        confirm_email
        log_in
        onboard

        assert_text "Experiments"
      end
    end

    private

    def sign_up
      fill_in "Name", with: "Test User"
      fill_in "Email", with: "test@example.com"
      fill_in "Choose a handle (alphanumeric)", with: "handle123"
      fill_in "Password (6 characters minimum)", with: "password"
      fill_in "Confirm password", with: "password"
      within("form") { click_on "Sign up" }
    end

    def confirm_email
      email = nil
      loop do
        email = ActionMailer::Base.deliveries.last

        break if email.present?
      end
      token = email.text_part.body.match(/confirmation_token=\w*/).to_s
      visit "/users/confirmation?#{token}"
      assert_text "Your email address has been successfully confirmed."
    end

    def log_in
      fill_in "Email address", with: "test@example.com"
      fill_in "Password", with: "password"
      within("form") { click_on "Log in" }
    end

    def onboard
      check "Accept Terms of Service"
      check "Accept Privacy Policy"
      click_on "Save and continue to Exercism"
    end
  end
end
