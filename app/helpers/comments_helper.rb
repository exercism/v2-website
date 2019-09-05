module CommentsHelper
  def allowed_to_comment?(user = current_user)
    AllowedToCommentPolicy.allowed?(user)
  end
end
