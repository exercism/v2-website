class SolutionsController < ApplicationController
  def show
    @solution = current_user.solutions.find(params[:id])
    @exercise = @solution.exercise
  end
end
