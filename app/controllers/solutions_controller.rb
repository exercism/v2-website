class SolutionsController < ApplicationController
  before_action :set_solution

  def show
    @exercise = @solution.exercise

    case @solution.status.to_sym
    when :unlocked
      show_unlocked
    when :cloned
      show_cloned
    when :iterating
      show_iterating
    when :completed_approved, :completed_unapproved
      show_completed
    else
      raise "Solution #{@solution.id} has a corrupt status: #{@solution.status}"
    end
  end

  def complete
    CompletesSolution.complete!(@solution)
    redirect_to @solution.exercise.track
  end

  private
  def set_solution
    @solution = current_user.solutions.find(params[:id])
  end

  def show_unlocked
    render :show_unlocked
  end

  def show_cloned
    render :show_cloned
  end

  def show_iterating
    @iteration = @solution.iterations.find_by_id(params[:iteration_id]) || @solution.iterations.first

    # TODO
    # If @iteration is null then the following page will break
    # so we need to guard. However, it means that the solution is
    # in the wrong state in the first place. Does this mean the
    # state machine approach is wrong (to be able to allow this)
    # or something else?

    render :show_iterating
  end

  def show_completed
    render :show_completed
  end
end
