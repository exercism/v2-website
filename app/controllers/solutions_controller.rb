class SolutionsController < ApplicationController
  def show
    @solution = current_user.solutions.find(params[:id])
    @exercise = @solution.exercise

    case @solution.status.to_sym
    when :unlocked
      show_unlocked
    when :cloned
      show_cloned
    when :iterating, :mentor_approved
      show_iterating
    when :user_completed, :mentor_completed
      show_completed
    else
      raise "Solution #{@solution.id} has a corrupt status: #{@solution.status}"
    end
  end

  private
  def show_unlocked
    render :show_unlocked
  end

  def show_cloned
    render :show_cloned
  end

  def show_iterating
    render :show_iterating
  end

  def show_completed
    render :show_completed
  end
end
