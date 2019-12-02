class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    html = ApplicationController.render(
      partial: "research/experiment_solutions/submission_status",
      locals: { submission: submission }
    )

    SolutionChannel.broadcast_to(
      submission.solution,
      {
        event: "submission_changed",
        html: html,
      }
    )
  end
end
