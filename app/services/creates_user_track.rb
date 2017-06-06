class CreatesUserTrack
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :user, :track
  def initialize(user, track)
    @user = user
    @track = track
  end

  def create!
    return false if UserTrack.where(user: user, track: track).exists?

    UserTrack.create!(user: user, track: track)
  end
end
