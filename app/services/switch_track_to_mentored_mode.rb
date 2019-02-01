class SwitchTrackToMentoredMode
  include Mandate

  initialize_with :user, :track

  def call
    user_track.update(independent_mode: false)
    user_track.solutions.update_all(track_in_independent_mode: false)

    FixUnlockingInUserTrack.(user_track)

    # Set at least one core solution to have mentoring
    unless user_track.solutions.core.where.not(mentoring_requested_at: nil).exists?
      user_track.solutions.core.
        joins(:exercise).
        order('exercises.position ASC').
        first.
        try {|s| s.update(mentoring_requested_at: Time.current) }
    end
  end

  memoize
  def user_track
    user.user_track_for(track)
  end
end
