class ExerciseMapNode < SimpleDelegator
  attr_reader :exercise, :unlocks

  def initialize(exercise:, unlocks:)
    @exercise = exercise
    @unlocks = unlocks

    super(exercise)
  end

  def unlocked_exercises
    unlocks.select(&:unlocked?)
  end
end
