class BroadcastSolutionJob < ApplicationJob
  def perform(solution)
    html = ApplicationController.render(
      partial: "my/solutions/solve/status",
      locals: { solution: solution }
    )

    SolutionChannel.broadcast_to(solution, html)
  end
end
