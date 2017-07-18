class My::SideExercisesController < MyController
  before_action :set_track

  def index
    exercises = @track.exercises.side
    exercises = exercises.where(difficulty: params[:difficulty]) if params[:difficulty].present?
    exercises = exercises.where(length: params[:length]) if params[:length].present?
    solutions = current_user.solutions.each_with_object({}) {|s,h| h[s.exercise_id] = s }
    @exercises_and_solutions = exercises.map{|ce|[ce, solutions[ce.id]]}
    if params[:status] == "locked"
      @exercises_and_solutions.keep_if {|e,s|!(s || !e.unlocked_by)}
    elsif params[:status] == "unlocked"
      @exercises_and_solutions.keep_if {|e,s|s || !e.unlocked_by}
    end
  end

  private
  def set_track
    @track = Track.find(params[:track_id])
  end
end

