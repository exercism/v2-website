class RetrieveSolutionsForMentor
  def self.retrieve(*args)
    new(*args).retrieve
  end

  attr_reader :user, :filter
  def initialize(user, filter)
    @user = user
    @filter = filter
  end

  def retrieve
    solutions = if filter.present? && respond_to?("retrieve_#{filter}")
        send("retrieve_#{filter}")
      else
        retrieve_require_action
      end
    solutions.includes(iterations: [], exercise: {track: []}, user: [:profile])
  end

  def retrieve_require_action
    user.mentored_solutions.
      where("solution_mentorships.abandoned": false).
      where("solution_mentorships.requires_action": true)
  end

  def retrieve_completed
    user.mentored_solutions.
      where("solution_mentorships.abandoned": false).
      completed.
      where("solution_mentorships.requires_action": false)
  end

  def retrieve_awaiting_user
    user.mentored_solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action": false).
      where("last_updated_by_user_at > ?", DateTime.now - 7.days)
  end

  def retrieve_stale
    user.mentored_solutions.
      where("solution_mentorships.abandoned": false).
      not_completed.
      where("solution_mentorships.requires_action": false).
      where("last_updated_by_user_at <= ?", DateTime.now - 7.days)
  end

  def retrieve_abandoned
    user.mentored_solutions.
      where("solution_mentorships.abandoned": true)
  end
end
