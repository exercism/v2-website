class Git::GithubProfile

  def self.for_user(username)
    auth_config = Rails.application.config_for("auth")
    github_key = auth_config["github_key"]
    github_secret = auth_config["github_secret"]
    client = Octokit::Client.new(client_id: github_key, client_secret: github_secret)
    user = client.user(username)
    self.new(user)
  end

  attr_reader :user, :name, :bio, :avatar_url, :link_url

  def initialize(user)
    @user = user
    @name = user.name.blank? ? user.login : user.name
    @bio = user.bio || ""
    @avatar_url = user.avatar_url
    @link_url = user.html_url
  end

end
