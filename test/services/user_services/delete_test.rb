require "test_helper"

module UserServices
  class DeleteTest < ActiveSupport::TestCase
    test "wipes user's details" do
      user = create(:user,
                    bio: "Short bio",
                    reset_password_token: "token",
                    reset_password_sent_at: Date.new(2016, 12, 25),
                    remember_created_at: Date.new(2016, 12, 25),
                    sign_in_count: 10,
                    current_sign_in_at: Date.new(2016, 12, 25),
                    last_sign_in_at: Date.new(2016, 12, 25),
                    current_sign_in_ip: "IP",
                    last_sign_in_ip: "IP",
                    confirmation_token: "token",
                    confirmed_at: Date.new(2016, 12, 25),
                    confirmation_sent_at: Date.new(2016, 12, 25),
                    unconfirmed_email: "email@gmail.com",
                    provider: "provider",
                    uid: "uid",
                    admin: true,
                    accepted_privacy_policy_at: Date.new(2016, 12, 25),
                    accepted_terms_at: Date.new(2016, 12, 25),
                    dark_code_theme: true,
                    is_mentor: true,
                    default_allow_comments: true,
                   )

      UserServices::Delete.(user)

      user.reload
      assert_equal "Deleted User", user.name
      assert_match /deleteduser(.*)/, user.handle
      assert_nil user.bio
      assert_match /deleteduser\+(.*)@exercism\.io/, user.email
      assert_nil user.reset_password_token
      assert_nil user.reset_password_sent_at
      assert_nil user.remember_created_at
      assert_equal 0, user.sign_in_count
      assert_nil user.current_sign_in_at
      assert_nil user.last_sign_in_at
      assert_nil user.current_sign_in_ip
      assert_nil user.last_sign_in_ip
      assert_nil user.confirmation_token
      assert_nil user.confirmed_at
      assert_nil user.confirmation_sent_at
      assert_nil user.unconfirmed_email
      assert_nil user.provider
      assert_nil user.uid
      refute user.admin?
      assert_nil user.accepted_privacy_policy_at
      assert_nil user.accepted_terms_at
      refute user.dark_code_theme?
      refute user.is_mentor?
      assert_nil user.default_allow_comments
    end
  end
end
