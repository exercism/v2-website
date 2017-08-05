class ExercisesController < ApplicationController
  def index
    @track = Track.find(params[:track_id])
    @exercises = @track.exercises
    @solutions = @exercise.solutions.published.includes(:user).limit(6)

    return redirect_to [:my, @track] if user_signed_in?
    return redirect_to [@track, @exercise], :status => :moved_permanently if request.path != track_exercises_path(@track)
  end

  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solutions = @exercise.solutions.published

    return redirect_to [:my, @track] if user_signed_in?
    return redirect_to [@track, @exercise], :status => :moved_permanently if request.path != track_exercise_path(@track, @exercise)
  end
end
