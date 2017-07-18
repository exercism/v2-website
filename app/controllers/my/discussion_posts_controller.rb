class My::DiscussionPostsController < MyController
  def create
    iteration = current_user.iterations.find(params[:iteration_id])
    if current_user == iteration.solution.user
      @post = CreatesUserDiscussionPost.create!(iteration, current_user, params[:discussion_post][:content])
    else
      @post = CreatesMentorDiscussionPost.create!(iteration, current_user, params[:discussion_post][:content])
    end
  end
end
