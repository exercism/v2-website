class ExerciseWithUnlockedExercises < SimpleDelegator
  def initialize(exercise, user)
    @exercise = exercise
    @user = user

    super(exercise)
  end

  def unlocked_exercises
    exercise.
      unlocks.
      map { |e| ExerciseWithSolution.new(e, user.solutions.find_by(exercise: e)) }.
      select(&:unlocked?)
  end

  private
  attr_reader :exercise, :user
end
