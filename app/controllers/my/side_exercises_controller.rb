class My::SideExercisesController < MyController
  before_action :set_track

  def index
    exercises = @track.exercises.side.active.includes(:topics)

    if params[:difficulty].strip.present?
      case params[:difficulty]
      when 'easy'
        exercises = exercises.where(difficulty: [1,2,3])
      when 'medium'
        exercises = exercises.where(difficulty: [4,5,6,7])
      when 'hard'
        exercises = exercises.where(difficulty: [8,9,10])
      end
    end

    exercises = exercises.joins(:exercise_topics).where("exercise_topics.topic_id": params[:topic_id]) if params[:topic_id].to_i > 0
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

