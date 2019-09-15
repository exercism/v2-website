class Teams::Teams::MySolutionsController < Teams::Teams::BaseController
  def index
    @solutions = TeamSolution.for_team_and_user(@team, current_user).joins(:exercise).includes(:exercise)
    @possible_tracks = Track.where(id: @solutions.joins(:exercise).
                                                  select("exercises.track_id").distinct)

    @track_id = params[:track_id]
    @track_id_options = OptionsHelper.as_options(@possible_tracks,
                                                 :title,
                                                 :id)

    @exercise_id = params[:exercise_id]
    @exercise_id_options = exercise_id_options

    @solutions = @solutions.where("exercises.track_id": @track_id) if @track_id.present?
    @solutions = @solutions.where("exercise_id": @exercise_id) if @exercise_id.present?
    @solutions = @solutions.includes(:user).
                            page(params[:page]).per(21)  end

  def show
    @solution = TeamSolution.find_by_uuid_for_team_and_user(params[:id], @team, current_user)
    @exercise = @solution.exercise

    ClearNotifications.(current_user, @solution)
    @solution.update(has_unseen_feedback: false)

    if @solution.iterations.size > 0
      show_started
    else
      show_unlocked
    end
  end

  def new
    @track_id_options = OptionsHelper.as_options(Track.all, :title, :id)
  end

  def possible_exercises
    @exercises = Track.find(params[:track_id]).exercises.active.reorder(:title)
  end

  def create
    @team_solution = CreateTeamSolution.(current_user, @team, Exercise.find(params[:exercise_id]))
    redirect_to teams_team_my_solution_path(@team, @team_solution)
  end

  private

  def show_unlocked
    render :show_unlocked
  end

  def show_started
    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration
    @iteration_idx = @solution.iterations.where("id < ?", @iteration.id).count + 1

    ClearNotifications.(current_user, @iteration)
  end

  def exercise_id_options
    track = Track.find_by(id: @track_id)
    return [] unless track

    exercises = TeamSolution.for_team_and_user(@team, current_user).
                             joins(:exercise).
                             includes(:exercise).
                             where('exercises.track_id': @track_id).
                             map(&:exercise)

    OptionsHelper.as_options(exercises, :title, :id)
  end

end
