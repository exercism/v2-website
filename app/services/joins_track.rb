class JoinsTrack
  def self.join!(*args)
    new(*args).join!
  end

  attr_reader :user, :track
  def initialize(user, track)
    @user = user
    @track = track
  end

  def join!
    return false if UserTrack.where(user: user, track: track).exists?

    user_track = UserTrack.create!(user: user, track: track)
    first_exercise = track.exercises.core.first
    CreatesSolution.create!(user, first_exercise) if first_exercise

    # BETA
    TrackMentorship.create!(user: user, track: track)

    return user_track
  end
end
