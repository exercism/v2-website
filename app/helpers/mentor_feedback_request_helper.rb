module MentorFeedbackRequestHelper
  def render_solution_mentor_feedback_request_section(scenario, solution, mentor_request = nil)
    mentor_request ||= MentorFeedbackRequest.new(solution)

    render "my/solutions/mentor_feedback_request/#{scenario}/#{mentor_request.status}",
      mentor_request: mentor_request
  end

  def render_mentor_feedback_request_notification(solution, mentor_request = nil)
    mentor_request ||= MentorFeedbackRequest.new(solution)

    render "my/solutions/mentor_feedback_request_notification/#{mentor_request.status}",
      mentor_request: mentor_request
  end
end
