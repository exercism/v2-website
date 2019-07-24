module UserServices
  class Delete
    include Mandate

    initialize_with :user

    def call
      redact_user_details
    end

    private

    def redact_user_details
      user.skip_reconfirmation!
      user.update!(
        name: "Deleted User",
        handle: "deleteduser#{SecureRandom.uuid}",
        bio: nil,
        email: "deleteduser+#{SecureRandom.uuid}@exercism.io",
        remember_created_at: nil,
        sign_in_count: 0,
        current_sign_in_at: nil,
        last_sign_in_at: nil,
        current_sign_in_ip: nil,
        last_sign_in_ip: nil,
        confirmation_token: nil,
        confirmed_at: nil,
        confirmation_sent_at: nil,
        unconfirmed_email: nil,
        provider: nil,
        uid: nil,
        admin: false,
        accepted_privacy_policy_at: nil,
        accepted_terms_at: nil,
        dark_code_theme: false,
        is_mentor: false,
        default_allow_comments: nil,
      )
    end
  end
end
