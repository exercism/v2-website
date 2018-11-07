class UnlockNextCoreExercise
  include Mandate

  initialize_with :track, :user

  def call
    if existing_core_exercise
      existing_core_exercise.update(mentoring_requested_at: Time.now) unless existing_core_exercise.mentoring_requested_at
      return existing_core_exercise
    end

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
  def existing_core_exercise
    user.
      solutions.
      joins(:exercise).
      where(exercises: { track: track, core: true }).
      where(completed_at: nil).
      first
  end
end
