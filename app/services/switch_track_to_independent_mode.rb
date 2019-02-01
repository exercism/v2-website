class SwitchTrackToIndependentMode
  include Mandate

  initialize_with :user, :track

  def call
    user_track.update(independent_mode: true)
    user_track.solutions.update_all(track_in_independent_mode: true)
  end

  memoize
  def user_track
    user.user_track_for(track)
  end
end
