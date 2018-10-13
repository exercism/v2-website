class My::PauseUserTracksController < MyController
  before_action :set_user_track

  def update
    PauseUserTrack.(@user_track)
    redirect_to my_tracks_path
  end

  def destroy
    UnpauseUserTrack.(@user_track)
    redirect_to my_track_path(@user_track.track)
  end

  private

  def set_user_track
    @user_track = current_user.user_tracks.find(params[:id])
  end
end
