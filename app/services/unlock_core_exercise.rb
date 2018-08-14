class UnlockCoreExercise
  include Mandate

  initialize_with :user, :exercise

  def call
    CreateSolution.(user, exercise)
  end
end
