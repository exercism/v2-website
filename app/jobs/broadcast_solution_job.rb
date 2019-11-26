class BroadcastSolutionJob < ApplicationJob
  def perform(solution)
    html = ApplicationController.render(
      partial: "my/solutions/solve/test_output",
      locals: { solution: solution }
    )

    SolutionChannel.broadcast_to(solution, html)
  end
end
