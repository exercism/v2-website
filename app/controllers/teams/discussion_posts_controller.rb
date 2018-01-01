class Teams::DiscussionPostsController < TeamsController
  def create
    @iteration = current_user.team_iterations.find(params[:iteration_id])
    @post = CreateTeamDiscussionPost.(@iteration, current_user, params[:discussion_post][:content])

    render "my/discussion_posts/create"
  end
end
