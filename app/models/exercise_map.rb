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
    exercises.
      map { |e| ExerciseWithStatus.new(e, solution_for(e)) }.
      map { |e| ExerciseMapNode.new(exercise: e, unlocks: exercises_to_unlock_for(e)) }
  end

  def solution_for(exercise)
    solutions.find { |solution| solution.exercise_id == exercise.id }
  end

  def solutions
    @solutions ||= user.
      solutions.
      includes(:approved_by).
      joins(:exercise).
      where(exercises: { track: track })
  end

  def exercises
    @exercises ||= track.exercises.includes(:unlocks)
  end

  def exercises_to_unlock_for(exercise)
    exercises = []
    exercises += bonus_exercises if exercise.auto_approve?
    exercises += exercise.unlocks

    exercises.map { |e| ExerciseWithStatus.new(e, solution_for(e)) }
  end

  def bonus_exercises
    @bonus_exercises ||= exercises.
      where(core: false, unlocked_by: nil).
      limit(10)
  end
end
