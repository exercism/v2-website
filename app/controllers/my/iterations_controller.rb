class My::IterationsController < MyController
  def show
    redirect_to my_solution_path(solution, iteration_idx: iteration_idx)
  end

  private

  def solution
    @solution ||= current_user.solutions.find_by_uuid!(params[:solution_id])
  end

  def iteration_idx
    iteration = solution.iterations.find(params[:id])

    solution.iterations.index(iteration) + 1
  end
end
