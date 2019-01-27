class SolutionsController < ApplicationController
  def index
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:exercise_id])

    @solutions = @exercise.solutions.published.reorder('solutions.published_at DESC').includes(:user)

    if user_signed_in?
      @solutions = @solutions.where.not(user_id: current_user.id)
      @current_user_track = UserTrack.where(user: current_user, track: @track).first
      @user_solution = current_user.solutions.
                                    where(exercise_id: @exercise.id).
                                    where("EXISTS(select id from iterations where solution_id = solutions.id)").
                                    first
    end

    @total_solutions = @solutions.count
    @solutions = @solutions.page(params[:page]).per(21)
    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }
  end

  def show
    @solution = Solution.published.find_by_uuid(params[:id])
    ClearNotifications.(current_user, @solution)

    # Allow /solutions/uuid to redirect, or if the solution isn't
    # valid (not published etc) then redirect to sensible place if
    # possible.
    if @solution
      @exercise = @solution.exercise
      @track = @exercise.track
      return redirect_to [@track, @exercise, @solution], :status => :moved_permanently if request.path != track_exercise_solution_path(@track, @exercise, @solution)

    elsif params[:track_id].present? && params[:exercise_id].present?
      @track = Track.find(params[:track_id])
      @exercise = @track.exercises.find(params[:exercise_id])

      begin
        @solution = @exercise.solutions.published.find_by_uuid!(params[:id])
      rescue
        return redirect_to [@track, @exercise]
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end

    @iteration = @solution.iterations.last
    @comments = @solution.comments.
                          order('created_at ASC').
                          includes(user: [:profile, { avatar_attachment: :blob }])
  end
end
