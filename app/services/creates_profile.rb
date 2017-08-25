class CreatesProfile
  def self.create(*args)
    new(*args).create
  end

  attr_reader :user, :display_name
  def initialize(user, display_name)
    @user = user
    @display_name = display_name
  end

  def create
    Profile.create(
      user: user,
      display_name: display_name
    )
  end
end
