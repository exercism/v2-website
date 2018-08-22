class ExerciseMapNode < SimpleDelegator
  def initialize(exercise:, unlocks:)
    @exercise = exercise
    @unlocks = unlocks

    super(exercise)
  end

  def unlocked_exercises
    unlocks.select(&:unlocked?)
  end

  private
  attr_reader :exercise, :unlocks
end
