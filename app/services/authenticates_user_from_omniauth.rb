class AuthenticatesUserFromOmniauth

  def self.authenticate(*args)
    new(*args).authenticate
  end

  attr_reader :auth, :initial_track_id
  def initialize(auth, initial_track_id = nil)
    @auth = auth
    @initial_track_id = initial_track_id
  end

  def authenticate
    user = User.where(provider: auth.provider, uid: auth.uid).first
    return user if user

    user = User.where(email: auth.info.email).first
    return user if user

    # TODO - catch any omniauth errors and do something sensible (currently you get a 500)
    user = User.create!(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0,20],
      name: auth.info.name,
      handle: handle,
      avatar_url: auth.info.image
    )
    BootstrapsUser.bootstrap(user, initial_track_id)
    user
  end

  def handle
    attempt = auth.info.nickname
    while UserTrack.where(handle: attempt).exists? ||
          User.where(handle: attempt).exists?
      attempt = "#{auth.info.nickname}-#{SecureRandom.random_number(10000)}"
    end
    attempt
  end
end
