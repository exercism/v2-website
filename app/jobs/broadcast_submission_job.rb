class BroadcastSubmissionJob < ApplicationJob
  def perform(submission)
    test_results = ApplicationController.render(
      partial: "research/experiment_solutions/test_results",
      locals: { results: submission.test_results }
    )

    SolutionChannel.broadcast_to(
      submission.solution,
      { status: submission.status, testResults: test_results }
    )
  end
end
