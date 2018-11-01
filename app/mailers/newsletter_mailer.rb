class NewsletterMailer < ApplicationMailer
  def side_exercise_changes
    @user = params[:user]
    mail(to: @user.email, subject: "[Exercism] We've changed mentoring on side exercises")
  end

  def mentor_changes_1
    @user = params[:user]
    mail(to: "#{@user.name} <#{@user.email}>", subject: "[Exercism] View your Mentor Rating")
  end
end
