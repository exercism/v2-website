module DefaultAllowCommentsHelper
  def show_decide_default_allow_comments_modal?
    return false unless user_signed_in?
    return false unless current_user.default_allow_comments === nil
    return false unless current_user.solutions.published.count > 0
    return true
  end
end
