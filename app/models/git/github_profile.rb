class Git::GithubProfile
  class NotFoundError < StandardError
  end

  def self.for_user(username)
    client = Octokit::Client.new(
      client_id: Rails.application.secrets.github_key,
      client_secret: Rails.application.secrets.github_secret
    )

    begin
      user = client.user(username)
    rescue Octokit::NotFound
      raise NotFoundError
    end

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

  def user_present?
    user && user.id
  end
end
