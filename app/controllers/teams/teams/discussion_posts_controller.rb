class Teams::Teams::DiscussionPostsController < Teams::Teams::BaseController
  def create
    @iteration = @team.iterations.find(params[:iteration_id])
    @post = CreateTeamDiscussionPost.(@iteration, current_user, params[:discussion_post][:content])

    render "my/discussion_posts/create"
  end
end
