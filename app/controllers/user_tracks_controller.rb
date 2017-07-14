class UserTracksController < ApplicationController
  def create
    track = Track.find(params[:track_id])
    JoinsTrack.start!(current_user, track)
    redirect_to track
  end
end
