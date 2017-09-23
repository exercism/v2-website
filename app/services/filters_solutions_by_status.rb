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
    solutions.includes(iterations: [], exercise: {track: []}, user: [:profile]).
              limit(20) # TODO - Paginate
  end

  def filter_require_action
    solutions.
      where("solution_mentorships.abandoned": false).
      where("solution_mentorships.requires_action": true)
  end

  def filter_completed
    solutions.
      where("solution_mentorships.abandoned": false).
      completed.
      where("solution_mentorships.requires_action": false)
  end

  def filter_awaiting_user
    solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action": false).
      where("last_updated_by_user_at > ?", DateTime.now - 7.days)
  end

  def filter_stale
    solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action": false).
      where("last_updated_by_user_at <= ?", DateTime.now - 7.days)
  end

  def filter_abandoned
    solutions.where("solution_mentorships.abandoned": true)
  end
end
