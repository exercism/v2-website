class ExercisesController < ApplicationController
  def index
    @track = Track.find(params[:track_id])
    @exercises = @track.exercises

    return redirect_to [:my, @track] if user_signed_in?
    return redirect_to [@track, @exercise], :status => :moved_permanently if request.path != track_exercises_path(@track)
  end

  def show
    @track = Track.find(params[:track_id])
    @exercise = @track.exercises.find(params[:id])
    @solutions = @exercise.solutions.published.reorder(num_reactions: :desc).includes(:user).limit(6)

    @reaction_counts = Reaction.where(solution_id: @solutions.pluck(:id)).group(:solution_id, :emotion).count
    @comment_counts = Reaction.where(solution_id: @solutions.pluck(:id)).with_comments.group(:solution_id).count
    @user_tracks = UserTrack.where(user_id: @solutions.pluck(:user_id), track: @track).
                             each_with_object({}) { |ut, h| h[ut.user_id] = ut }

    if user_signed_in? && current_user.joined_track?(@track)
      return redirect_to [@track, anchor: "exercise-#{@exercise.slug}"]
    end

    return redirect_to [@track, @exercise], :status => :moved_permanently if request.path != track_exercise_path(@track, @exercise)
  end
end
