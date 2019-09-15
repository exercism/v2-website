class SolutionCommentsMailer < ApplicationMailer
  def new_comment_for_solution_user(user, comment)
    @unsubscribe_key = :email_on_new_solution_comment_for_solution_user

    @user = user
    @comment = comment
    @solution = comment.solution
    @exercise_title = @solution.exercise.title
    @track_title = @solution.track.title
    mail(
      to: @user.email,
      subject: "[Exercism] Someone has commented on your solution to #{@track_title}/#{@exercise_title}"
    )
  end

  def new_comment_for_other_commenter(user, comment)
    @unsubscribe_key = :email_on_new_solution_comment_for_other_commenter

    @user = user
    @comment = comment
    @solution = comment.solution

    @exercise_title = @solution.exercise.title
    @track_title = @solution.track.title
    @solution_user_handle = @solution.user.handle_for(@solution.exercise.track)

    mail(
      to: @user.email,
      subject: "[Exercism] Someone else has commented on #{@solution_user_handle}'s solution to #{@track_title}/#{@exercise_title}"
    )
  end
end

