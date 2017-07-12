class TracksController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return index_signed_out unless user_signed_in?

    tracks = Track.all
    unlocked_track_ids = current_user.user_tracks.pluck(:track_id)

    @unlocked_tracks, @locked_tracks = tracks.partition {|t|unlocked_track_ids.include?(t.id)}
  end

  def show
    return show_signed_out unless user_signed_in?

    @track = Track.find(params[:id])
    return render :show_locked unless current_user.unlocked_track?(@track)

    exercises = @track.exercises.order('position ASC, title ASC')
    core_exercises, side_exercises = exercises.partition {|e|e.core?}

    # Make this just for this track maybe?
    # Not sure whether it'll make it faster or slower
    solutions = current_user.solutions.includes(:exercise)
    mapped_solutions = solutions.each_with_object({}) {|s,h| h[s.exercise_id] = s }

    @user_track = UserTrack.where(user: current_user, track: @track).first
    @core_exercises_and_solutions = core_exercises.map{|ce|[ce, mapped_solutions[ce.id]]}
    @side_exercises_and_solutions = side_exercises.map{|ce|[ce, mapped_solutions[ce.id]]}
    @num_side_exercises = @track.exercises.side.count
    @num_solved_core_exercises = solutions.select { |s| s.exercise.core? && s.exercise.track_id == @track.id && s.completed?}.size
    @num_solved_side_exercises = solutions.select { |s| s.exercise.side? && s.exercise.track_id == @track.id && s.completed?}.size

    # TODO
    @topic_percentages = {
      strings: 10,
      transforming: 55,
      "regular expressions": 95
    }
  end

  private
  def index_signed_out
    @tracks = Track.all
    render :index_signed_out
  end

  def show_signed_out
    @track = Track.find(params[:id])
    render :show_signed_out
  end
end
