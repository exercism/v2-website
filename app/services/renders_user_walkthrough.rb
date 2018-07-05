class RendersUserWalkthrough
  include Mandate

  CONFIGURE_COMMAND = "[CONFIGURE_COMMAND]"

  def initialize(user, walkthrough)
    @user = user
    @walkthrough = walkthrough
  end

  def call
    substitute_tokens!

    walkthrough
  end

  private
  attr_reader :user, :walkthrough

  def substitute_tokens!
    walkthrough.gsub!(CONFIGURE_COMMAND, "exercism configure --token=#{user.auth_token}")
  end
end
