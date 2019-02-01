class ProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to action: :index
  end

  before_action :set_profile, except: [:index]

  def show
    @profile_view = ProfilePresenter.new(@profile, track_id: params[:track_id])
  end

  def index
    @profiles = Profile.order("profiles.created_at ASC").includes(:user).page(params[:page]).per(100)
  end

  def solutions
    @profile_view = ProfilePresenter.new(@profile, track_id: params[:track_id])
  end

  private

  def set_profile
    @user = User.find_by_handle!(params[:id])
    @profile = @user.profile

    raise ActiveRecord::RecordNotFound unless @profile
  end
end
