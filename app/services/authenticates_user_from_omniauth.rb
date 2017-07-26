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

    # TODO - catch any omniauth errors and do something sensible (currently you get a 500)
    user = User.create!(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0,20],
      name: auth.info.name,
      # TODO - handle nickname/handle clashes
      handle: auth.info.nickname
      #avatar_url: auth.info.image # TODO
    )
    BootstrapsUser.bootstrap(user)
    user
  end
end
