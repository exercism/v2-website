class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    BroadcastSolutionJob.perform_now(submission.solution)
  end
end
