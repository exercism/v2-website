class TracksController < ApplicationController
  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])

    return redirect_to @track, :status => :moved_permanently if request.path != track_path(@track)
  end
end

