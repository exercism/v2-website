class BroadcastSolutionJob < ApplicationJob
  def perform(solution)
    submission = solution.submissions.last

    html = ApplicationController.render(
      partial: submission.ops_status,
      as: :status
    )

    ResearchSolutionChannel.broadcast_to(solution, {
      opsStatus: submission.ops_status,
      html: html,
    }.compact)
  end
end
