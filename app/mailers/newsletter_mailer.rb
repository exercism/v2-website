class NewsletterMailer < ApplicationMailer
  def side_exercise_changes
    @user = params[:user]
    mail(to: @user.email, subject: "[Exercism] We've changed mentoring on side exercises")
  end

  def mentor_changes_1
    @user = params[:user]
    mail(to: "#{@user.name} <#{@user.email}>", subject: "[Exercism] View your Mentor Rating")
  end

  def mentor_thanks_2018
    @user = params[:user]
    mail(
      to: "#{@user.name} <#{@user.email}>",
      reply_to: "jeremy@exercism.io",
      subject: "[Exercism] Thanks for being a mentor this year"
    )
  end

  def mentor_jan_2019
    @user = params[:user]
    mail(
      to: "#{@user.name} <#{@user.email}>",
      reply_to: "jeremy@exercism.io",
      subject: "[Exercism] We've improved lots during January"
    )
  end
end
