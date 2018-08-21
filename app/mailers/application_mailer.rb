class ApplicationMailer < ActionMailer::Base
  default from: "The Exercism Team <hello@exercism.io>"
  layout 'mailer'

  rescue_from EOFError do |exception|
    raise "Unable to connect to SMTP server. Please check https://twitter.com/sparkpostops"
  end
end
