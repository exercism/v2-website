class BroadcastSolutionJob < ApplicationJob
  def perform(solution)
    submission = solution.submissions.last

    test_run_html = if submission.test_run
                      ApplicationController.render(
                        partial: submission.test_run,
                        as: :test_run
                      )
                    end

    ops_status_html = ApplicationController.render(
      partial: submission.ops_status,
      as: :status
    )

    ResearchSolutionChannel.broadcast_to(solution, {
      opsStatus: submission.ops_status,
      opsStatusHtml: ops_status_html,
      testRunHtml: test_run_html,
    }.compact)
  end
end
