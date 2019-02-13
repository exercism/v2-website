class My::UserTracksController < MyController
  before_action :set_user_track, except: [:create]

  def create
    track = Track.find(params[:track_id])

    if current_user.previously_joined_track?(track)
      user_track = current_user.user_tracks.find_by(track: track)
      UnpauseUserTrack.(user_track)
    else
      JoinTrack.(current_user, track)
    end

    redirect_to [:my, track]
  end

  def set_mentored_mode
    SwitchTrackToMentoredMode.(current_user, @user_track.track)

    respond_to do |format|
      format.js { render js: "$('#modal .main-section').hide();$('#modal .start-section').show()" }
      format.html { redirect_to [:my, @user_track.track] }
    end
  end

  def set_independent_mode
    SwitchTrackToIndependentMode.(current_user, @user_track.track)

    respond_to do |format|
      format.js { render js: "window.closeModal()" }
      format.html { redirect_to [:my, @user_track.track] }
    end
  end

  def leave
    ActiveRecord::Base.transaction do
      @user_track.solutions.destroy_all
      @user_track.destroy!
    end

    redirect_to my_tracks_path
  end

  def pause
    PauseUserTrack.(@user_track)
    redirect_to my_tracks_path
  end

  def unpause
    UnpauseUserTrack.(@user_track)
    redirect_to my_track_path(@user_track.track)
  end

  private
  def set_user_track
    @user_track = current_user.user_tracks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to my_tracks_path
  end
end
