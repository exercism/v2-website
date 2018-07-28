class Mentor::SolutionsController < MentorController
  before_action :set_solution
  before_action :check_mentor_may_mentor_solution!

  def show
    @exercise = @solution.exercise
    @track = @exercise.track

    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration

    @comments = @solution.reactions.with_comments.includes(user: [:profile, { avatar_attachment: :blob }])
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
    @solution_user_track = UserTrack.where(user: @solution.user, track: @track).first

    @user_tracks = UserTrack.where(track: @track, user_id: @iteration.discussion_posts.map(&:user_id)).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }

    if current_user == @iteration.solution.user
      return redirect_to [:my, @solution]
    end

    ClearsNotifications.clear!(current_user, @solution)
    ClearsNotifications.clear!(current_user, @iteration)
  end

  def approve
    ApproveSolution.(@solution, current_user)
  end

  def ignore
    IgnoredSolutionMentorship.find_or_create_by(user: current_user, solution: @solution)
    redirect_to [:mentor, :dashboard]
  end

  def abandon
    @mentor_solution = SolutionMentorship.where(user: current_user, solution: @solution).first
    @mentor_solution.update(abandoned: true)
    redirect_to [:mentor, :dashboard]
  end

  private

  def set_solution
    @solution = Solution.find_by_uuid!(params[:id])
  end

  def check_mentor_may_mentor_solution!
    return head 403 if current_user == @solution.user

    return true if current_user.mentoring_solution?(@solution)
    return true if current_user.mentoring_track?(@solution.exercise.track)

    head 403
  end
end
