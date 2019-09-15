class ExerciseMap
  include Mandate
  initialize_with :user, :track

  def core_exercises
    exercises.select(&:core?).map do |exercise|
      ExerciseMapNode.new(
        exercise: exercise,
        solution: solution_for(exercise),
        unlocks: exercises_to_unlock_for(exercise)
      )
    end
  end

  private
  attr_reader :user, :track

  memoize
  def exercises
    track.exercises.includes(:unlocks)
  end

  def solution_for(exercise)
    solutions.find { |solution| solution.exercise_id == exercise.id }
  end

  memoize
  def solutions
    user.solutions.
         includes(:approved_by).
         joins(:exercise).
         where(exercises: { track: track })
  end

  def exercises_to_unlock_for(exercise)
    exercises = []
    exercises += bonus_exercises if exercise.auto_approve?
    exercises += exercise.unlocks

    exercises.map do |e|
      ExerciseMapNode.new(
        exercise: e,
        solution: solution_for(e)
      )
    end
  end

  memoize
  def bonus_exercises
    exercises.where(core: false, unlocked_by: nil).
              limit(10)
  end
end
