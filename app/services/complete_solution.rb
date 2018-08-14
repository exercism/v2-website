class CompleteSolution
  include Mandate

  initialize_with :solution

  def call
    if solution.approved?
      completed_approved
    else
      completed_unapproved
    end

    unlock_next_core_exercise if solution.exercise.core?
  end

  private

  def completed_approved
    update_solution_record

    # Unlock side quests
    existing_exercise_ids = user.solutions.pluck(:exercise_id)
    solution.exercise.unlocks.each do |exercise|
      next if existing_exercise_ids.include?(exercise.id)
      CreateSolution.(user, exercise)
    end
  end

  def completed_unapproved
    update_solution_record
  end

  def update_solution_record
    solution.update!( completed_at: Time.current )
  end

  def unlock_next_core_exercise
    UnlockNextCoreExercise.(solution.track, solution.user)
  end

  def user
    solution.user
  end
end
