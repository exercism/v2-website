class My::UserTracksController < MyController
  def create
    track = Track.find(params[:track_id])
    JoinsTrack.start!(current_user, track)
    redirect_to [:my, track]
  end
end
