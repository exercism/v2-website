class NewsletterMailer < ApplicationMailer
  def side_exercise_changes
    @user = params[:user]
    mail(to: @user.email, subject: "We've changed how mentoring works")
  end
end
