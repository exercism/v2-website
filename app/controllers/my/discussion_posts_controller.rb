class My::DiscussionPostsController < MyController
  def create
    @iteration = current_user.iterations.find(params[:iteration_id])
    @post = CreatesUserDiscussionPost.create!(@iteration, current_user, params[:discussion_post][:content])
  end
end
