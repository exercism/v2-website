class SolutionsController < ApplicationController
  before_action :set_solution

  def show
    @exercise = @solution.exercise

    if @solution.completed?
      show_completed
    elsif @solution.iterations.size > 0
      show_iterating
    else
      show_unlocked
    end
  end

  def confirm_unapproved_completion
    render_modal('solution-confirm-unapproved-completion', "confirm_unapproved_completion")
  end

  def complete
    CompletesSolution.complete!(@solution)
    render_modal("solution-completed", "complete")
  end

  def reflection
    render_modal("solution-reflection", "reflection")
  end

  def reflect
    @solution.update(notes: params[:notes])
    (params[:mentor_reviews] || {}).each do |mentor_id, data|
      CreatesMentorReview.create(
        current_user,
        User.find(mentor_id),
        @solution,
        data[:rating],
        data[:feedback]
      )
    end
    render_modal("solution-unlocked", "unlocked")
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
    @track = @solution.exercise.track
    @user_track = UserTrack.where(user: current_user, track: @track).first

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
