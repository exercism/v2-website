class SolutionsController < ApplicationController
  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solution = @exercise.solutions.published.find(params[:id])
    @iteration = @solution.iterations.last
    @profile = @solution.user.profile || Profile.new(
      name: "Anonymous", 
      avatar_url: "" # TODO
    )
  end
end
