class JoinsTrack
  def self.start!(*args)
    new(*args).start!
  end

  attr_reader :user, :track
  def initialize(user, track)
    @user = user
    @track = track
  end

  def start!
    return false if UserTrack.where(user: user, track: track).exists?

    user_track = UserTrack.create!(user: user, track: track)
    CreatesSolution.create!(user, track.exercises.core.first)

    return user_track
  end
end
