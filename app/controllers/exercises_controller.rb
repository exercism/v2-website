class ExercisesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @track = Track.find(params[:track_id])
    return redirect_to [:my, @track] if user_signed_in?

    @exercises = @track.exercises.active

    return redirect_to [@track, :exercises], :status => :moved_permanently if request.path != track_exercises_path(@track)
  end

  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solutions = @exercise.solutions.published.reorder(published_at: :desc).includes(:user).limit(6)

    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }

    if user_signed_in? && current_user.joined_track?(@track)
      return redirect_to [@track, anchor: "exercise-#{@exercise.slug}"]
    end

    return redirect_to [@track, @exercise], :status => :moved_permanently if request.path != track_exercise_path(@track, @exercise)
  end
end
