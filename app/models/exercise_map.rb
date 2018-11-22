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
      joins("LEFT OUTER JOIN solutions ON exercises.id = solutions.exercise_id AND solutions.user_id = #{user.id}").
      includes(:unlocks).
      map { |e| ExerciseWithSolution.new(e, e.solutions.first) }
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
