class DeviseMailerPreview < ActionMailer::Preview
  #def confirmation_instructions
  #  DeviseMailer.confirmation_instructions(User.first, "faketoken", {})
  #end

  def reset_password_instructions
    DeviseMailer.reset_password_instructions(User.first, "faketoken", {})
  end
end
