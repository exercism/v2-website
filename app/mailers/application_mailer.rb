class ApplicationMailer < ActionMailer::Base
  default from: "The Exercism Team <hello@mail.exercism.io>",
          reply_to: "hello@exercism.io"

  layout 'mailer'

  helper :a11y

  class UnableToConnectToSMTPServerError < StandardError
  end

  rescue_from EOFError do |exception|
    raise UnableToConnectToSMTPServerError, "Unable to connect to SMTP server. Please check https://twitter.com/sparkpostops"
  end
end
