class Mentor::RegistrationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :restrict_to_non_mentors!

  def index
  end

  def new
    load_tracks
    @errors = []
  end

  def create
    command = MakeUserAMentor.new(current_user, params[:track_id])

    command.()

    if command.success?
      redirect_to mentor_dashboard_path
    else
      load_tracks
      @errors = command.errors

      render :new
    end
  end

  private

  def restrict_to_non_mentors!
    return unless user_signed_in?
    return unless current_user.is_mentor?
    redirect_to mentor_dashboard_path
  end

  def load_tracks
    @tracks = Track.active.order(:title).map{|t|[t.title, t.id]}
  end
end
