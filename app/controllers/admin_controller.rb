class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_authorised!

  private

  def restrict_to_admins!
    return if current_user.admin?

    redirect_to root_path, status: 401
  end

  def restrict_to_authorised!
    return if current_user.admin?

    redirect_to root_path, status: 401
  end
end
