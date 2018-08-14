class JoinTrack
  include Mandate

  initialize_with :user, :track

  def call
    return false if UserTrack.where(user: user, track: track).exists?

    user_track = UserTrack.create!(user: user, track: track)
    first_exercise = track.exercises.core.first
    CreateSolution.(user, first_exercise) if first_exercise

    return user_track
  end
end
