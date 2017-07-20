class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_admins!

  private

  def restrict_to_admins!
    return if current_user.admin?

    redirect_to root_path, status: 401
  end
end
