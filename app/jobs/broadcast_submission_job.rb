class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    test_run = ApplicationController.render(
      partial: "research/experiment_solutions/test_run",
      locals: { test_run: submission.test_run }
    )

    ResearchSolutionChannel.broadcast_to(
      submission.solution,
      { status: submission.status, testRun: test_run }
    )
  end
end
