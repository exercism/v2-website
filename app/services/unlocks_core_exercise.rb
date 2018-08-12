class UnlocksCoreExercise
  include Mandate

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def call
    CreateSolution.(user, exercise)
  end

  private

  attr_reader :exercise, :user
end
