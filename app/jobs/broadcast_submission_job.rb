class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    html = ApplicationController.render(
      partial: "my/submissions/submission",
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
