class FiltersSolutionsByStatus
  def self.filter(*args)
    new(*args).filter
  end

  attr_reader :solutions, :status

  def initialize(solutions, status)
    @solutions = solutions
    @status = status
  end

  def filter
    @solutions = if status.present? && respond_to?("filter_#{status}")
        send("filter_#{status}")
      else
        filter_require_action
      end
    solutions.includes(iterations: [], exercise: {track: []}, user: [:profile])
  end

  def filter_require_action
    solutions.
      where("solutions.paused": false).
      merge( SolutionMentorship.active.requires_action )
  end

  def filter_completed
    solutions.
      completed.
      where("solution_mentorships.abandoned": false).
      where("solution_mentorships.requires_action_since": nil)
  end

  def filter_awaiting_user
    solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action_since": nil).
      where("last_updated_by_user_at > ?", Time.current - 7.days).
      where("solutions.paused": false)
  end

  def filter_stale
    solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action_since": nil).
      where("last_updated_by_user_at <= ?", Time.current - 7.days).
      where("last_updated_by_user_at > ?", Exercism::V2_MIGRATED_AT).
      where("solutions.paused": false)
  end

  def filter_legacy
    solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action_since": nil).
      where("last_updated_by_user_at <= ?", Exercism::V2_MIGRATED_AT)
  end

  def filter_unsubscribed
    solutions.where("(solution_mentorships.abandoned = ?) OR
                     (
                       solutions.completed_at IS NULL AND
                       solutions.paused = ?
                     )", true, true)
  end
end
