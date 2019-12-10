class BroadcastSolutionJob < ApplicationJob
  def perform(solution)
    submission = solution.submissions.last

    test_run_html = ApplicationController.render(
      partial: submission.test_run,
      as: :test_run
    )

    ops_status_html = ApplicationController.render(
      partial: submission.ops_status.to_partial_path,
      locals: { status: submission.ops_status }
    )

    ResearchSolutionChannel.broadcast_to(solution, {
      opsStatus: submission.ops_status,
      opsStatusHtml: ops_status_html,
      testRunHtml: test_run_html,
    })
  end
end
