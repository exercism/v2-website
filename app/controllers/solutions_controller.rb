class SolutionsController < ApplicationController
  def index
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:exercise_id])

    @solutions = @exercise.solutions.published.includes(:user)

    if user_signed_in?
      @solutions = @solutions.where.not(user_id: current_user.id)
      @current_user_track = UserTrack.where(user: current_user, track: @track).first
      @user_solution = current_user.solutions.
                                    where(exercise_id: @exercise.id).
                                    where("EXISTS(select id from iterations where solution_id = solutions.id)").
                                    first
    end

    @total_solutions = @solutions.count
    @solutions = @solutions.page(params[:page]).per(20)

    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }
  end

  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:exercise_id])

    begin
      @solution = @exercise.solutions.published.find_by_uuid!(params[:id])
    rescue
      return redirect_to [@track, @exercise]
    end

    @iteration = @solution.iterations.last
    @comments = @solution.reactions.with_comments.includes(user: :profile)
    @reaction_counts = @solution.reactions.group(:emotion).count.to_h
  end
end
