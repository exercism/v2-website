class My::SettingsController < ApplicationController
  def show
    @user = User.find(current_user.id)
    @user_tracks = current_user.user_tracks.includes(:track)
  end

  def update
  end
end
