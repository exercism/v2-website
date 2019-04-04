# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class UserNotificationsMailerPreview < ActionMailer::Preview
  def new_discussion_post
    UserNotificationsMailer.new_discussion_post(User.first, DiscussionPost.first)
  end

  def remind_about_solution_with_unapproved_solution
    UserNotificationsMailer.remind_about_solution(User.first, Solution.not_approved.first, [Solution.approved.first, Solution.not_approved.first])
  end

  def remind_about_solution_with_approved_solution
    UserNotificationsMailer.remind_about_solution(User.first, Solution.approved.first, [Solution.approved.first, Solution.not_approved.first])
  end
end
