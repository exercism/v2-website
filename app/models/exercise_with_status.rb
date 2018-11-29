class ExerciseWithStatus < SimpleDelegator
  attr_reader :solution

  delegate :approved?, :in_progress?, to: :solution

  def initialize(exercise, solution)
    @exercise = exercise
    @solution = solution

    super(exercise)
  end

  def status
    return "Locked" if locked?

    if completed?
      "Completed"
    elsif approved?
     "Approved"
    elsif in_progress?
      "In progress"
    elsif unlocked?
      "Unlocked"
    end
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
  delegate :user, to: :solution

  attr_reader :exercise
end
