class ExerciseMapNode < SimpleDelegator
  attr_reader :exercise, :solution, :unlocks

  def initialize(exercise:, solution:, unlocks: [])
    @exercise = exercise
    @solution = solution
    @unlocks = unlocks

    super(exercise)
  end

  def status
    return "Locked" if locked?

    if solution.completed?
      "Completed"
    elsif in_progress?
      "In progress"
    elsif approved?
     "Approved"
    elsif unlocked?
      "Unlocked"
    end
  end

  def unlocked?
    solution.present?
  end

  def locked?
    !unlocked?
  end

  def in_progress?
    solution.try(:in_progress?)
  end

  def approved?
    solution.try(:approved?)
  end

  def completed?
    solution.try(:completed?)
  end

  def unlocked_exercises
    unlocks.select(&:unlocked?)
  end
end
