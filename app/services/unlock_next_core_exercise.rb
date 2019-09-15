class UnlockNextCoreExercise
  include Mandate

  initialize_with :track, :user

  def call
    if existing_core_solution
      if existing_core_solution.iterations.exists? && !existing_core_solution.mentoring_requested?
        existing_core_solution.update(mentoring_requested_at: Time.now)
      end
      return existing_core_solution
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
  def existing_core_solution
    user.
      solutions.
      joins(:exercise).
      where(exercises: { track: track, core: true }).
      where(completed_at: nil).
      first
  end
end
