class MakeUserAMentor
  include Mandate
  include ActiveModel::Validations

  initialize_with :user, :track_id

  def call
    unless allowed_to_mentor?
      errors.add(
        :base,
        "You must submit at least one solution before becoming a mentor."
      )

      return
    end

    make_mentor
    create_track_mentorship
    invite_to_slack
  end

  def success?
    errors.empty?
  end

  def make_mentor
    user.update(is_mentor: true)
  end

  def create_track_mentorship
    user.track_mentorships.create(track_id: track_id)
  end

  def invite_to_slack
    data = {
      email: user.email,
      token: Rails.application.secrets.slack_api_token,
      set_active: 'true'
    }
    RestClient.post(slack_api_invite_url, data)
  rescue SocketError => e
    raise e if Rails.env.production?
  end

  def slack_api_invite_url
    Rails.env.production?? "https://exercism-mentors.slack.com/api/users.admin.invite" :
                           "https://dev.null.exercism.io"
  end

  private

  def allowed_to_mentor?
    AllowedToMentorPolicy.allowed?(user)
  end
end
