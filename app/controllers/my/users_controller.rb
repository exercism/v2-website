class My::UsersController < MyController
  def update
    current_user.update!(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:theme)
  end
end
