class Git::GithubProfile

  def self.for_user(username)
    client = Octokit::Client.new
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
