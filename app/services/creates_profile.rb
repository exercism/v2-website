class CreatesProfile
  class ProfileSlugAvailableError < RuntimeError
  end

  def self.create(*args)
    new(*args).create
  end

  attr_reader :user, :name, :slug
  def initialize(user, name, slug)
    @user = user
    @name = name
    @slug = sanitize_slug(slug)
  end

  def create
    Profile.create(
      user: user,
      name: name,
      slug: slug
    )
  end

  private

  def sanitize_slug(s)
    s.gsub(/[^[a-zA-Z0-9]]/, '').downcase
  end
end
