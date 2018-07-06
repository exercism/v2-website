class RendersUserWalkthrough
  include Mandate

  CONFIGURE_COMMAND_TOKEN = "[CONFIGURE_COMMAND]"

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
    walkthrough.gsub!(
      CONFIGURE_COMMAND_TOKEN,
      ApplicationController.render(
        partial: "widgets/code_snippet",
        locals: { code: configure_command(user.auth_token) }
      )
    )
  end

  def configure_command(token)
    "exercism configure --token=%s" % [token]
  end
end
