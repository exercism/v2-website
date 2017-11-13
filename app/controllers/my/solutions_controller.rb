class My::SolutionsController < MyController
  before_action :set_solution, except: [:create]

  def create
    track = Track.find(params[:track_id])
    user_track = UserTrack.where(user: current_user, track: track).first
    exercise = track.exercises.find(params[:exercise_id])

    if current_user.may_unlock_exercise?(user_track, exercise)
      solution = CreatesSolution.create!(current_user, exercise)
      redirect_to [:my, solution]
    else
      redirect_to [:my, track]
    end
  end

  def show
    @exercise = @solution.exercise
    ClearsNotifications.clear!(current_user, @solution)

    @track = @solution.exercise.track
    @user_track = UserTrack.where(user: current_user, track: @track).first

    if @solution.iterations.size > 0
      show_started
    else
      show_unlocked
    end
  end

  def walkthrough
    @walkthrough = Git::WebsiteContent.head.walkthrough['compiled.html']
    render_modal("solution-walkthrough", "walkthrough")
  end

  def request_mentoring
    @solution.enable_mentoring!
    redirect_to action: :show
  end

  def confirm_unapproved_completion
    render_modal('solution-confirm-unapproved-completion', "confirm_unapproved_completion")
  end

  def complete
    CompletesSolution.complete!(@solution)
    @exercise = @solution.exercise
    @track = @exercise.track
    @num_completed_exercises = current_user.solutions.where(exercise_id: @track.exercises).completed.count
    render_modal("solution-completed", "complete")
  end

  def reflection
    @mentor_interations = @solution.discussion_posts.group(:user_id).count
    render_modal("solution-reflection", "reflection")
  end

  def reflect
    @solution.update(reflection: params[:reflection])
    @solution.update(published_at: DateTime.now) if params[:publish]

    (params[:mentor_reviews] || {}).each do |mentor_id, data|
      ReviewsSolutionMentoring.review!(
        @solution,
        User.find(mentor_id),
        data[:rating],
        data[:feedback]
      )
    end

    @track = @solution.exercise.track
    user_track = UserTrack.where(user: current_user, track: @track).first

    if user_track.normal_mode?
      if @solution.exercise.core?
        @next_core_exercise = current_user.solutions.not_completed.
                              joins(:exercise).
                              where("exercises.track_id": @track.id).
                              where("exercises.core": true).
                              first.try(&:exercise)
      end

      unlocked_side_exercises = @solution.exercise.unlocks
      unlocked_solutions = current_user.solutions.
                                        where(exercise_id: unlocked_side_exercises).
                                        each_with_object({}) { |s,h| h[s.exercise_id] = s }
      @unlocked_side_exercises_and_solutions = unlocked_side_exercises.each_with_object([]) do |e, a|
        a << [e, unlocked_solutions[e.id]]
      end
    end

    if @next_core_exercise || @unlocked_side_exercises.present?
      render_modal("solution-unlocked", "unlocked")
    else
      js_redirect_to(@track)
    end
  end

  def publish
    @solution.update(published_at: DateTime.now) if params[:publish]
    redirect_to [@solution.exercise.track, @solution.exercise, @solution]
  end

  private
  def set_solution
    @solution = current_user.solutions.find_by_uuid!(params[:id])
  end

  def show_unlocked
    render :show_unlocked
  end

  def show_started
    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration
    @iteration_idx = @solution.iterations.where("id < ?", @iteration.id).count + 1
    @num_iterations = @solution.iterations.count

    @post_user_tracks = UserTrack.where(user_id: @iteration.discussion_posts.map(&:user_id), track: @track).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }

    render :show
  end
end
