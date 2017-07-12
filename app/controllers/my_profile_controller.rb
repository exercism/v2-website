class MyProfileController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_profile_exists!, only: [:new, :create]
  before_action :redirect_unless_profile_exists!, only: [:show, :edit, :update, :destroy]

  def show
    redirect_to @profile
  end

  def new
    redirect_to profile_path if current_user.profile
    @profile = Profile.new(name: current_user.name)
  end

  def create
    @profile = CreatesProfile.create(
      current_user,
      params[:profile][:name],
      params[:profile][:slug]
    )
    if @profile.persisted?
      redirect_to action: :edit
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    @profile.update(profile_params)
    redirect_to @profile
  end

  private

  def profile_params
    params.require(:profile).permit(
      :name, :slug, :bio,
      :website, :twitter, :github, :linkedin, :medium
    )
  end

  def set_profile
    @profile = current_user.profile
  end

  def redirect_if_profile_exists!
    profile = current_user.profile
    redirect_to profile_path(profile) if profile
  end

  def redirect_unless_profile_exists!
    redirect_to new_my_profile_path unless @profile
  end
end
