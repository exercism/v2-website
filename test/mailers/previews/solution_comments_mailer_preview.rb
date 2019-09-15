# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class SolutionCommentsMailerPreview < ActionMailer::Preview
  def new_comment_for_solution_user
    SolutionCommentsMailer.new_comment_for_solution_user(User.first, SolutionComment.first)
  end

  def new_comment_for_other_commenter
    SolutionCommentsMailer.new_comment_for_other_commenter(User.first, SolutionComment.first)
  end
end

