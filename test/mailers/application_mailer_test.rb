require 'test_helper'

class ApplicationMailerTest < ActionMailer::TestCase
  test "rescues EOFError" do
    assert_raises "Unable to connect to SMTP server. Please check https://twitter.com/sparkpostops" do
      ErrorMailer.eof_error.deliver_now
    end
  end
end

class ErrorMailer < ApplicationMailer
  def eof_error
    raise EOFError
  end
end
