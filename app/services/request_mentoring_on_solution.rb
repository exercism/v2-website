class RequestMentoringOnSolution
  include Mandate

  initialize_with :solution

  def call
    return unless request.can_be_accommodated?

    post_system_messages! if solution.approved_by_system?
    update_solution!
  end

  private

  def request
    MentorFeedbackRequest.new(solution)
  end

  def user_track
    solution.user.user_track_for(solution.track)
  end

  def post_system_messages!
    CreateSystemDiscussionPost.(
      'system_messages.solution_mentoring_request_for_auto_approved',
      solution.iterations.last
    )
  end

  def update_solution!
    solution.update(
      completed_at: nil,
      published_at: nil,
      approved_by: nil,
      last_updated_by_user_at: Time.current,
      mentoring_requested_at: Time.current,
      updated_at: Time.current
    )
  end
end
