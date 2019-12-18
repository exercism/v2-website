class Admin::IterationsController < AdminController
  before_action :restrict_to_admins!

  def show
    solution = Solution.find_by_uuid!(params[:solution_id])
    iteration = solution.iterations.find(params[:id])
    iteration_idx = solution.iterations.index(iteration) + 1

    redirect_to admin_solution_path(solution, iteration_idx: iteration_idx)
  end
end
