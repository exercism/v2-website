class Teams::SolutionsController < TeamsController
  def index
    @solutions = @team.solutions.where.not(user_id: current_user.id).
                       includes(:user).
                       page(params[:page]).per(21)
  end

  def show
    @solution = TeamSolution.where(team: @team).find_by_uuid(params[:id])
    @exercise = @solution.exercise

    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration
    @iteration_idx = @solution.iterations.where("id < ?", @iteration.id).count + 1
    @num_iterations = @solution.iterations.count
  end
end
