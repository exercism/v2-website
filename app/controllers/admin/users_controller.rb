class Admin::UsersController < AdminController
  def show
    @user = User.find(params[:id])
    @discussion_posts = @user.discussion_posts.includes(iteration: :solution)
  end
end
