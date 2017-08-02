class Mentor::SolutionsController < MentorController
  def show
    @solution = Solution.find(params[:id])
    @exercise = @solution.exercise
    @track = @exercise.track

    #return redirect_to [:mentor, :dashboard] unless current_user.mentoring_track?(@track)

    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration
    @iteration_idx = @solution.iterations.where("id < ?", @iteration.id).count + 1
    @num_iterations = @solution.iterations.count

    @comments = @solution.reactions.with_comments.includes(user: :profile)
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
    @solution_user_track = UserTrack.where(user: @solution.user, track: @track)
  end
end
