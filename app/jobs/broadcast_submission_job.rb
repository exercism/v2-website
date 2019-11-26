class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    html = ApplicationController.render(
      partial: "my/solutions/solve/status",
      locals: { submission: submission }
    )

    SubmissionChannel.broadcast_to(submission, html)
  end
end
