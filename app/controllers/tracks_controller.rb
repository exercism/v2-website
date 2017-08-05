class TracksController < ApplicationController
  def index
    return redirect_to [:my, :tracks] if user_signed_in?

    @tracks = Track.order('title ASC')
    @all_exercise_counts = Exercise.where(track_id: @tracks).group(:track_id).count
    @all_user_tracks_counts = UserTrack.where(track_id: @tracks).group(:track_id).count
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
