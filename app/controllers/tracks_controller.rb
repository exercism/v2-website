class TracksController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return index_signed_out unless user_signed_in?

    tracks = Track.all
    unlocked_track_ids = current_user.user_tracks.pluck(:track_id)

    @unlocked_tracks, @locked_tracks = tracks.partition {|t|unlocked_track_ids.include?(t.id)}
  end

  def show
    return show_signed_out unless user_signed_in?

    @track = Track.find(params[:id])
    return render :show_locked unless current_user.unlocked_track?(@track)
  end

  private
  def index_signed_out
    @tracks = Track.all
    render :index_signed_out
  end

  def show_signed_out
    @track = Track.find(params[:id])
    render :show_signed_out
  end
end
