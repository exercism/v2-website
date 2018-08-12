class Teams::Teams::MySolutionsController < Teams::Teams::BaseController
  def index
    @solutions = TeamSolution.for_team_and_user(@team, current_user).joins(:exercise).includes(:exercise)

    if params[:difficulty].to_s.strip.present?
      case params[:difficulty]
      when 'easy'
        @solutions = @solutions.where('exercises.difficulty': [1,2,3])
      when 'medium'
        @solutions = @solutions.where('exercises.difficulty': [4,5,6,7])
      when 'hard'
        @solutions = @solutions.where('exercises.difficulty': [8,9,10])
      end
    end

    @solutions = @solutions.joins(:exercise_topics).where("exercise_topics.topic_id": params[:topic_id]) if params[:topic_id].to_i > 0
    @solutions = @solutions.where('exercises.length': params[:length]) if params[:length].to_i > 0

    exercises = @solutions.map(&:exercise)
    topic_counts = exercises.each_with_object({}) do |e, topics|
      e.topics.each do |topic|
        topics[topic] ||= 0
        topics[topic] += 1
      end
    end
    @topics_for_select = topic_counts.keys.map{|t|[t.name.titleize, t.id]}.sort_by{|t|t[0]}.unshift(["Any", 0])
  end

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
end
