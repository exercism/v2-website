class Mentor::SolutionsController < MentorController
  def show
    @solution = Solution.find(params[:id])
    @exercise = @solution.exercise
    @track = @exercise.track

    return redirect_to mentor_dashboard unless current_user.mentoring_track?(@track)

    @iteration = @solution.iterations.last
    @comments = @solution.reactions.with_comments.includes(user: :profile)
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
    @solution_user_track = UserTrack.where(user: @solution.user, track: @track)
  end
end
