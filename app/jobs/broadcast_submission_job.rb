class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    SolutionChannel.broadcast_to(
      submission.solution,
      { status: submission.status }
    )
  end
end
