class ExercisesController < ApplicationController
  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solutions = @exercise.solutions.published
  end
end
