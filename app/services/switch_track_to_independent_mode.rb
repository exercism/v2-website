class SwitchTrackToIndependentMode
  include Mandate

  attr_reader :user, :track
  def initialize(user, track)
    @user = user
    @track = track
  end

  def call
    user_track.update(independent_mode: true)
    user_track.solutions.not_completed.update_all(independent_mode: true)
  end

  memoize
  def user_track
    user.user_track_for(track)
  end
end

