class TracksController < ApplicationController
  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
    @mentors = @track.mentorships
    @maintainers = @track.maintainers
    @exercises = @track.exercises.limit(6)

    return redirect_to @track, :status => :moved_permanently if request.path != track_path(@track)
  end
end

