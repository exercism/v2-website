class CreatesProfile
  class ProfileSlugAvailableError < RuntimeError
  end

  def self.create(*args)
    new(*args).create
  end

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def create
    Profile.create(
      user: user,
      display_name: display_name
    )
  end

  private

  def display_name
    user.name.present?? user.name : user.handle
  end

  def slug
    user.handle.gsub(/[^[a-zA-Z0-9]]/, '').downcase
  end
end
