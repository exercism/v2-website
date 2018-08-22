class UnlockNextCoreExercise
  include Mandate

  initialize_with :track, :user

  def call
    return core_exercise_in_progress if core_exercise_in_progress

    next_exercise = track.exercises.core.
                                    locked_for(user).
                                    order(:position).
                                    first

    if next_exercise
      UnlockCoreExercise.(user, next_exercise)
    else
      # TODO Complete
      # raise "Not Implemented"
    end
  end

  private

  memoize
  def core_exercise_in_progress
    user.
      solutions.
      joins(:exercise).
      where(exercises: { track: track, core: true }).
      where(completed_at: nil).
      first
  end
end
