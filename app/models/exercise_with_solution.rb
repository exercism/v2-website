class ExerciseWithSolution < SimpleDelegator
  attr_reader :solution

  def initialize(exercise, solution)
    @exercise = exercise
    @solution = solution

    super(exercise)
  end

  def locked?
    solution.blank?
  end

  def unlocked?
    solution.present?
  end

  def completed?
    solution.present? && solution.completed?
  end

  private
  attr_reader :exercise
end
