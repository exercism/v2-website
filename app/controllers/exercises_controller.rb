class ExercisesController < ApplicationController
  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solutions = @exercise.solutions.published

    return redirect_to [@track, @exercise], :status => :moved_permanently if request.path != track_exercise_path(@track, @exercise)
  end
end
