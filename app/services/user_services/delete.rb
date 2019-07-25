module UserServices
  class Delete
    include Mandate

    def initialize(user, time: Time.current)
      @user = user
      @time = time
    end

    def call
      redact_user_details
      delete_user_associations
      mark_as_deleted
    end

    private
    attr_reader :user, :time

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
        dark_code_theme: false,
        is_mentor: false,
        default_allow_comments: nil,
      )
    end

    def delete_user_associations
      user.auth_tokens.destroy_all
      user.notifications.destroy_all
      user.team_memberships.destroy_all
      user.team_sent_invitations.destroy_all
      user.user_tracks.destroy_all
      user.solutions.destroy_all
      user.team_solutions.destroy_all
      user.track_mentorships.destroy_all
      user.track_maintainerships.update_all(user_id: nil)
      user.solution_mentorships.destroy_all
      user.solution_locks.destroy_all
      user.ignored_solution_mentorships.destroy_all
      user.discussion_posts.update_all(user_id: nil)
      user.solution_comments.destroy_all
      user.blog_comments.destroy_all
      user.solution_stars.destroy_all
      user.avatar.purge

      user.email_log.destroy if user.email_log
      user.profile.destroy if user.profile
      user.communication_preferences.destroy if user.communication_preferences
    end

    def mark_as_deleted
      user.update!(deleted_at: time)
    end
  end
end
