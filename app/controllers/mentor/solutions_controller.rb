class Mentor::SolutionsController < MentorController
  before_action :set_solution
  before_action :check_mentor_may_view_solution!
  before_action :check_mentor_may_mentor_solution!, except: [:show]

  def show
    if current_user == @solution.user
      return redirect_to [:my, @solution]
    end

    @exercise = @solution.exercise
    @track = @exercise.track

    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration

    @comments = @solution.comments.includes(user: [:profile, { avatar_attachment: :blob }])
    @solution_user_track = UserTrack.where(user: @solution.user, track: @track).first

    @user_tracks = UserTrack.where(track: @track, user_id: @iteration.discussion_posts.map(&:user_id)).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }

    @current_user_lock = SolutionLock.find_by(solution: @solution, user: current_user)

    @mentoring_notes_created = RetrieveMentorExerciseNotes.(@track, @exercise).present?

    ClearNotifications.(current_user, @solution)
    ClearNotifications.(current_user, @iteration)

    # Redact if a solution is approved or being mentored and you're not the mentor
    @redact_users = (@solution.approved? || @solution.num_mentors > 0) &&
                    !current_user.mentoring_solution?(@solution)
  end

  def approve
    ApproveSolution.(@solution, current_user)
  end

  def ignore
    IgnoredSolutionMentorship.find_or_create_by(user: current_user, solution: @solution)
    redirect_to [:mentor, :dashboard]
  end

  def ignore_requires_action
    @mentor_solution = SolutionMentorship.where(user: current_user, solution: @solution).first
    @mentor_solution.update(requires_action_since: nil)
    redirect_to mentor_dashboard_path
  end

  def abandon
    mentorship = SolutionMentorship.where(user: current_user, solution: @solution).first
    if mentorship
      AbandonSolutionMentorship.(mentorship, :left_conversation)
    else
      mentorship = CreateSolutionMentorship.(@solution, current_user)
      AbandonSolutionMentorship.(mentorship, nil)
    end

    redirect_to [:mentor, :dashboard]
  end

  def lock
    @solution_locked = LockSolution.(current_user, @solution, force: !!params[:force])

    respond_to do |format|
      format.js
      format.html { redirect_to action: :show }
    end
  end

  private

  def set_solution
    @solution = Solution.find_by_uuid!(params[:id])
  end

  def check_mentor_may_view_solution!
    return redirect_to [:my, @solution] if current_user == @solution.user
    return true if current_user.is_mentor?

    head 403
  end

  def check_mentor_may_mentor_solution!
    return true if current_user.mentoring_solution?(@solution)
    return true if current_user.mentoring_track?(@solution.exercise.track)

    head 403
  end
end
