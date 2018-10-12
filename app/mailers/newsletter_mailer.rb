class NewsletterMailer < ApplicationMailer
  def side_exercise_changes
    @user = params[:user]
    mail(to: @user.email, subject: "[Exercism] We've changed mentoring on side exercises")
  end
end
