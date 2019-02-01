# Preview all emails at http://localhost:3000/rails/mailers/newsletter_mailer
class NewsletterMailerPreview < ActionMailer::Preview
   def side_exercise_changes
    NewsletterMailer.with(user: User.first).side_exercise_changes
  end

   def mentor_changes_1
    NewsletterMailer.with(user: User.first).mentor_changes_1
  end

   def mentor_thanks_2018
    NewsletterMailer.with(user: User.first).mentor_thanks_2018
  end

   def mentor_jan_2019
    NewsletterMailer.with(user: User.first).mentor_jan_2019
  end

end
