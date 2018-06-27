class UnlocksCoreExercise
  include Mandate

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def call
    return if exercise.unlocked_by_user?(user)

    CreatesSolution.create!(user, exercise)
  end

  private
  attr_reader :exercise, :user
end
