class AuthenticatesUserFromOmniauth

  def self.authenticate(*args)
    new(*args).authenticate
  end

  attr_reader :auth
  def initialize(auth)
    @auth = auth
  end

  def authenticate
    user = User.where(provider: auth.provider, uid: auth.uid).first
    return user if user

    user = User.create!(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0,20],
      name: auth.info.name,
      #avatar_url: auth.info.image # TODO
    )
    BootstrapsUser.bootstrap(user)
    user
  end
end
