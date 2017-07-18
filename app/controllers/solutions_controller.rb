class SolutionsController < ApplicationController
  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solution = @exercise.solutions.published.find(params[:id])
    @iteration = @solution.iterations.last
    @comments = @solution.reactions.with_comments.includes(user: :profile)
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
  end
end
