class Mentor::RegistrationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :restrict_to_non_mentors!

  def index
  end

  def new
    @tracks = Track.active.order(:title).map{|t|[t.title, t.id]}
  end

  def create
    MakeUserAMentor.(current_user, params[:track_id])
    redirect_to mentor_dashboard_path
  end

  private

  def restrict_to_non_mentors!
    return unless user_signed_in?
    return unless current_user.is_mentor?
    redirect_to mentor_dashboard_path
  end
end
