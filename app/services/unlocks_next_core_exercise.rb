class UnlocksNextCoreExercise
  include Mandate

  def initialize(solution)
    @solution = solution
  end

  def call
    next_exercise = exercise.track.exercises.where(core: true).
                      reorder('position ASC').
                      where("position > ?", exercise.position).
                      first
    if next_exercise
      # Don't double-create
      unless user.solutions.where(exercise_id: next_exercise.id).exists?
        CreatesSolution.create!(user, next_exercise)
      end
    else
      # TODO - complete track
      raise "Not Implemented"
    end
  end

  private
  attr_reader :solution

  delegate :user, to: :solution
  delegate :exercise, to: :solution
end
