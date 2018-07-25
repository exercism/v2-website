class Admin::SolutionsController < AdminController
  def show
    @solution = Solution.find_by_uuid(params[:id])
    @exercise = @solution.exercise
    @track = @exercise.track

    @iteration = @solution.iterations.offset(params[:iteration_idx].to_i - 1).first if params[:iteration_idx].to_i > 0
    @iteration = @solution.iterations.last unless @iteration

    @comments = @solution.reactions.with_comments.includes(user: [:profile, { avatar_attachment: :blob }])
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
    @solution_user_track = UserTrack.where(user: @solution.user, track: @track).first

    @user_tracks = UserTrack.where(track: @track, user_id: @iteration.discussion_posts.map(&:user_id)).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }

  end
end

