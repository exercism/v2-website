class My::SideExercisesController < MyController
  before_action :set_track

  # TODO - Update the num_exercise in the template
  def index
    exercises = @track.exercises.side.active.includes(:topics)
    exercises = exercises.where(difficulty: params[:difficulty]) if params[:difficulty].to_i > 0
    exercises = exercises.where(length: params[:length]) if params[:length].to_i > 0
    solutions = current_user.solutions.each_with_object({}) {|s,h| h[s.exercise_id] = s }
    @exercises_and_solutions = exercises.map{|ce|[ce, solutions[ce.id]]}
    if params[:status] == "unlocked"
      @exercises_and_solutions.keep_if {|e,s|(s && !s.in_progress?) || (!s && !e.unlocked_by)}
    elsif params[:status] == "in_progress"
      @exercises_and_solutions.keep_if {|e,s|s && s.in_progress? && !s.completed?}
    elsif params[:status] == "completed"
      @exercises_and_solutions.keep_if {|e,s|s && s.completed?}
    elsif params[:status] == "locked"
      @exercises_and_solutions.keep_if {|e,s|!(s || !e.unlocked_by)}
    end
  end

  private
  def set_track
    @track = Track.find(params[:track_id])
  end
end

