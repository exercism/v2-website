class RenderUserWalkthrough
  include Mandate

  CONFIGURE_COMMAND_TOKEN = "[CONFIGURE_COMMAND]"

  initialize_with :user, :walkthrough

  def call
    substitute_tokens!

    walkthrough
  end

  private

  def substitute_tokens!
    walkthrough.gsub!(
      CONFIGURE_COMMAND_TOKEN,
      configure_command(auth_token)
    )
  end

  def configure_command(token)
    "exercism configure --token=%s" % [token]
  end

  def auth_token
    user ? user.auth_token : "[TOKEN]"
  end
end
