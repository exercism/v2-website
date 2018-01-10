class Teams::SolutionsController < TeamsController
  def index

    @possible_tracks = Track.where(id: @team.solutions.where.not(user_id: current_user.id).
                                                       where("num_iterations > 0").
                                                       joins(:exercise).
                                                       select("exercises.track_id").distinct)

    @track_id = params[:track_id]
    @track_id_options = OptionsHelper.as_options(@possible_tracks,
                                                 :title,
                                                 :id)

    @exercise_id = params[:exercise_id]
    @exercise_id_options = exercise_id_options

    @solutions = @team.solutions.where.not(user_id: current_user.id).
                                 where("num_iterations > 0").
                                 joins(:exercise)
    @solutions = @solutions.where("exercises.track_id": @track_id) if @track_id.present?
    @solutions = @solutions.where("exercise_id": @exercise_id) if @exercise_id.present?
    @solutions = @solutions.includes(:user).
                            page(params[:page]).per(21)

  end

  def show
    @solution = TeamSolution.where(team: @team).find_by_uuid(params[:id])
    @exercise = @solution.exercise

    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration
    @iteration_idx = @solution.iterations.where("id < ?", @iteration.id).count + 1
  end

  private
  def exercise_id_options
    track = Track.find_by(id: @track_id)
    return [] unless track

    OptionsHelper.as_options(track.exercises, :title, :id)
  end

end
