class ApplicationMailer < ActionMailer::Base
  default from: "The Exercism Team <hello@exercism.io>"
  layout 'mailer'
end
