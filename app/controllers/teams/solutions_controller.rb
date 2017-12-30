class Teams::SolutionsController < TeamsController
  def index
    @solutions = @team.solutions.where.not(user_id: current_user.id).
                       includes(:user).
                       page(params[:page]).per(21)
  end
end
