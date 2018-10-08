class Mentor::RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_non_mentors!

  def new

  end

  def create
    current_user.update(is_mentor: true)
    redirect_to mentor_configure_path
  end

  private

  def restrict_to_non_mentors!
    return unless current_user.is_mentor?
    redirect_to mentor_dashboard_path
  end
end
