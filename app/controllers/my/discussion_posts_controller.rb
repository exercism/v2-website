class My::DiscussionPostsController < MyController
  def create
    @iteration = current_user.iterations.find(params[:iteration_id])
    @post = CreatesUserDiscussionPost.create!(@iteration, current_user, params[:discussion_post][:content])
    @user_track = UserTrack.where(user: current_user, track: @iteration.solution.exercise.track).first
  end

  def update
    @post = current_user.discussion_posts.find(params[:id])
    @iteration = @post.iteration
    @user_track = UserTrack.where(user: current_user, track: @iteration.solution.exercise.track).first

    @post.update!(
      previous_content: [@post.previous_content, @post.content].compact.join("\n---\n"),
      content: discussion_post_params[:content],
      html: ParseMarkdown.(discussion_post_params[:content]),
      edited: true
    )
  end

  def destroy
    @post = current_user.discussion_posts.find(params[:id])
    @iteration = @post.iteration
    @user_track = UserTrack.where(user: current_user, track: @iteration.solution.exercise.track).first

    @post.update!(deleted: true)
  end

  private

  def discussion_post_params
    params.require(:discussion_post).permit(:content)
  end
end
