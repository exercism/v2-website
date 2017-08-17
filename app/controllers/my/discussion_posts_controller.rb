class My::DiscussionPostsController < MyController
  def create
    @iteration = current_user.iterations.find(params[:iteration_id])
    @post = CreatesUserDiscussionPost.create!(@iteration, current_user, params[:discussion_post][:content])
    @user_track = UserTrack.where(user: current_user, track: @iteration.solution.exercise.track).first
  end
end
