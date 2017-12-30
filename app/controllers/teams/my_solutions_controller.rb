class Teams::MySolutionsController < TeamsController
  def index
    @solutions = TeamSolution.for_team_and_user(@team, current_user)
  end

  def show
    @solution = TeamSolution.find_by_uuid_for_team_and_user(params[:id], @team, current_user)
    @exercise = @solution.exercise
    ClearsNotifications.clear!(current_user, @solution)

    if @solution.iterations.size > 0
      show_started
    else
      show_unlocked
    end
  end

  def show_unlocked
    render :show_unlocked
  end

  def show_started
    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration
    @iteration_idx = @solution.iterations.where("id < ?", @iteration.id).count + 1
    @num_iterations = @solution.iterations.count
  end
end
