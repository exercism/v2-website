class CompletesSolution
  def self.complete!(*args)
    new(*args).complete!
  end

  attr_reader :solution
  def initialize(solution)
    @solution = solution
  end

  def complete!
    if solution.approved?
      completed_approved
    else
      completed_unapproved
    end

    unlock_next_core_exercise if solution.exercise.core?
  end

  private

  def completed_approved
    update_solution_record(:completed_approved)

    # Unlock side quests
    solution.exercise.unlocks.each do |exercise|
      Solution.create(user: solution.user, exercise: exercise, status: :unlocked)
    end
  end

  def completed_unapproved
    update_solution_record(:completed_unapproved)
  end

  def update_solution_record(status)
    solution.update!(
      completed_at: DateTime.now,
      status: status
    )
  end

  def unlock_next_core_exercise
    next_exercise = solution.exercise.track.exercises.where(core: true).
                      order('position ASC').
                      where("position > ?", solution.exercise.position).
                      first
    if next_exercise
      Solution.create(user: solution.user, exercise: next_exercise, status: :unlocked)
    else
      # TODO - complete track
      raise "Not Implemented"
    end
  end
end

