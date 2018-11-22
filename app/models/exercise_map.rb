class ExerciseMap
  include Mandate

  def initialize(user, track)
    @user = user
    @track = track
  end

  def core_exercises
    map.select(&:core?)
  end

  private
  attr_reader :user, :track

  memoize
  def map
    exercises.map do |e|
      ExerciseMapNode.new(
        exercise: ExerciseWithSolution.new(e, solutions[e.id]),
        unlocks: exercises_to_unlock_for(e)
      )
    end
  end

  memoize
  def exercises
    track.exercises.includes(:unlocks)
  end

  memoize
  def solutions
    user.solutions.where(exercise: exercises).each_with_object({}){|s,h|h[s.exercise_id] = s}
  end

  def exercises_to_unlock_for(exercise)
    bonus_exercises = if exercise.auto_approve?
                        exercises.
                          select(&:side?).
                          select { |e| e.unlocked_by.blank? }[0, 10]
                      else
                        []
                      end

    unlocked_exercises = exercise.unlocks.map do |exercise_to_unlock|
      exercises.find { |e| e.id == exercise_to_unlock.id }
    end

    bonus_exercises + unlocked_exercises
  end
end
