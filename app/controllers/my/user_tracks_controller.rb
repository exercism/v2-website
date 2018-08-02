class My::UserTracksController < MyController
  def create
    track = Track.find(params[:track_id])

    if current_user.previously_joined_track?(track)
      user_track = current_user.user_tracks.find_by(track: track)

      user_track.update!(archived_at: nil)
    else
      JoinsTrack.join!(current_user, track)
    end

    redirect_to [:my, track]
  end

  def set_mentored_mode
    user_track = current_user.user_tracks.find(params[:id])
    SwitchTrackToMentoredMode.(current_user, user_track.track)

    respond_to do |format|
      format.js { render js: "$('#modal .main-section').hide();$('#modal .start-section').show()" } 
      format.html { redirect_to [:my, user_track.track] }
    end
  end

  def set_independent_mode
    user_track = current_user.user_tracks.find(params[:id])
    SwitchTrackToIndependentMode.(current_user, user_track.track)

    respond_to do |format|
      format.js { render js: "window.closeModal()" } 
      format.html { redirect_to [:my, user_track.track] }
    end
  end

  def leave
    user_track = current_user.user_tracks.find(params[:id])

    ActiveRecord::Base.transaction do
      user_track.solutions.destroy_all
      user_track.destroy!
    end

    redirect_to my_tracks_path
  end
end
