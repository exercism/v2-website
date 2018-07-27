class SwitchTrackToMentoredMode
  include Mandate

  attr_reader :user, :track
  def initialize(user, track)
    @user = user
    @track = track
  end

  def call
    user_track.update(independent_mode: false)
    user_track.solutions.update_all(track_in_independent_mode: false)

    # Delete all unsubmitted exercises
    user_track.solutions.not_started.destroy_all

    # Get the core exercises and unlock their dependants
    exercise_ids = Exercise.core.where(id: user_track.solutions.completed.map(&:exercise_id)).pluck(:id)
    Exercise.where(unlocked_by: exercise_ids).each { |e|CreateSolution.(user, e) }

    # Make sure there is one unlocked core
    UnlocksNextCoreExercise.(track, user)

    # Set everything that's not started to mentored mode
    user_track.solutions.update_all(independent_mode: true)
    user_track.solutions.not_started.update_all(independent_mode: false)
  end

  memoize
  def user_track
    user.user_track_for(track)
  end
end
