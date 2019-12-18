class Admin::UsersController < AdminController
  before_action :restrict_to_admins!

  def show
    if params[:id].present?
      @user = User.find_by_id(params[:id])
    elsif params[:handle].present?
      @user = User.find_by_handle(params[:handle])
      @user = UserTrack.find_by_handle(params[:handle]).user unless @user
    end

    @discussion_posts = @user.discussion_posts.includes(iteration: :solution).
                                               order('id desc')
  end
end
