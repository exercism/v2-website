module MentorHelper
  def allowed_to_mentor?(user = current_user)
    AllowedToMentorPolicy.allowed?(user)
  end
end
