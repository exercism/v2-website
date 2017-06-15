class DiscussionPostsController < ApplicationController
  def create
    iteration = current_users.iterations.find(params[:id])
    CreatesDiscussionPost.create!(iteration, current_user, content)
  end
end
