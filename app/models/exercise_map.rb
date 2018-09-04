class ExerciseMap
  def initialize(user, track)
    @user = user
    @track = track
  end

  def core_exercises
    map.select(&:core?)
  end

  private
  attr_reader :user, :track

  def map
    @map ||= exercises.map do |e|
      ExerciseMapNode.new(
        exercise: e,
        unlocks: exercises_to_unlock_for(e)
      )
    end
  end

  def exercises
    @exercises ||= track.
      exercises.
      map { |e| ExerciseWithSolution.new(e, solution_for(e)) }
  end

  def exercises_to_unlock_for(exercise)
    if exercise.auto_approve?
      return exercises.
        select(&:side?).
        select { |e| e.unlocked_by.blank? }[0, 10]
    end

    exercise.unlocks.map do |exercise_to_unlock|
      exercises.find { |e| e.id == exercise_to_unlock.id }
    end
  end

  def solution_for(exercise)
    solutions.find { |solution| solution.exercise_id == exercise.id }
  end

  def solutions
    @solutions ||= user.
      solutions.
      includes(:exercise).
      where(exercises: { track: track })
  end
end
