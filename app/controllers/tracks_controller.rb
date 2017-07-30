class TracksController < ApplicationController
  def index
    @tracks = Track.all
    return redirect_to [:my, :tracks] if user_signed_in? 
  end

  def show
    @track = Track.find(params[:id])
    return redirect_to [:my, @track] if user_signed_in? 

    @mentors = @track.mentorships
    @maintainers = @track.maintainers
    @exercises = @track.exercises.limit(6)

    return redirect_to @track, :status => :moved_permanently if request.path != track_path(@track)
  end
end
