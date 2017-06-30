class BootstrapsUser
  def self.bootstrap(*args)
    new(*args).bootstrap
  end

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def bootstrap
    user.auth_tokens.create!(token: SecureRandom.uuid)
  end
end
