class UnlocksNextCoreExercise
  include Mandate

  def initialize(solution)
    @solution = solution
  end

  def call
    return if core_exercises_in_progress?

    next_exercise = exercise.
      track.
      exercises.
      joins("LEFT OUTER JOIN `solutions` ON `solutions`.`exercise_id` = `exercises`.`id` AND `solutions`.`user_id` = #{user.id}").
      where(solutions: { id: nil }).
      order(:position).
      first

    if next_exercise
      UnlocksCoreExercise.(user, next_exercise)
    else
      # TODO - complete track
      raise "Not Implemented"
    end
  end

  private
  attr_reader :solution

  delegate :user, to: :solution
  delegate :exercise, to: :solution

  def core_exercises_in_progress?
    user.
      solutions.
      joins(:exercise).
      where(exercises: { track: exercise.track, core: true }).
      where(completed_at: nil).
      exists?
  end
end
