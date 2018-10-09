class Mentor::RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_non_mentors!

  def new
    @tracks = Track.active.order(:title).map{|t|[t.title, t.id]}
  end

  def create
    current_user.update(is_mentor: true)
    current_user.track_mentorships.create(track_id: params[:track_id])
    redirect_to mentor_dashboard_path
  end

  private

  def restrict_to_non_mentors!
    return unless current_user.is_mentor?
    redirect_to mentor_dashboard_path
  end
end
