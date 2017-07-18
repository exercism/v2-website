class ProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to action: :index
  end

  def show
    @profile = Profile.find_by_slug!(params[:id])
    @track = Track.find_by_id(params[:track_id])
    @solutions = @profile.user.solutions.published
    @solutions = @solutions.where(track_id: track.id) if @track
  end

  def index
    @profiles = Profile.page(params[:page]).per(20)
  end

end
