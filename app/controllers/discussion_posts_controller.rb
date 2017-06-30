class DiscussionPostsController < ApplicationController
  def create
    iteration = current_user.iterations.find(params[:iteration_id])
    CreatesDiscussionPost.create!(iteration, current_user, params[:discussion_post][:content])
  end
end
