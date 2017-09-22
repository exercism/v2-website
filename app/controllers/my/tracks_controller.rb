class My::TracksController < MyController
  skip_before_action :authenticate_user!, only: [:show]

  def index
    tracks = Track.order('title ASC')
    tracks = tracks.where("title like ?", "%#{params[:title]}%") if params[:title].present?
    joined_track_ids = current_user.user_tracks.pluck(:track_id)

    @joined_tracks, @other_tracks = tracks.partition {|t|joined_track_ids.include?(t.id)}
    @completed_exercise_counts = current_user.solutions.completed.joins(:exercise).group(:track_id).count
    @all_exercise_counts = Exercise.where(track_id: tracks).group(:track_id).count
    @all_user_tracks_counts = UserTrack.where(track_id: tracks).group(:track_id).count
  end

  # OPTIMISE - Move all of this into some sort of helper service class
  def show
    @track = Track.find(params[:id])
    return redirect_to @track unless user_signed_in?
    return show_not_joined unless current_user.joined_track?(@track)

    exercises = @track.exercises.includes(:topics)
    normal_exercises, deprecated_exercises = exercises.partition {|e|e.active?}
    core_exercises, side_exercises = normal_exercises.partition {|e|e.core?}

    solutions = current_user.solutions.includes(:exercise).where('exercises.track_id': @track.id)
    mapped_solutions = solutions.each_with_object({}) {|s,h| h[s.exercise_id] = s }

    @user_track = UserTrack.where(user: current_user, track: @track).first
    @core_exercises_and_solutions = core_exercises.map{|e|[e, mapped_solutions[e.id]]}
    @side_exercises_and_solutions = side_exercises.map{|e|[e, mapped_solutions[e.id]]}
    @deprecated_exercises_and_solutions = deprecated_exercises.map { |e|
      solution = mapped_solutions[e.id]
      solution && solution.iterations.size > 0 ? [e, solution] : nil
    }.compact
    @num_side_exercises = @track.exercises.side.count
    @num_solved_core_exercises = solutions.select { |s| s.exercise.core? && s.exercise.track_id == @track.id && s.completed?}.size
    @num_solved_side_exercises = solutions.select { |s| s.exercise.side? && s.exercise.track_id == @track.id && s.completed?}.size

    topic_counts = exercises.each_with_object({}) do |e, topics|
      e.topics.each do |topic|
        topics[topic] ||= 0
        topics[topic] += 1
      end
    end

    user_topic_counts = solutions.completed.each_with_object({}) do |s, topics|
      s.exercise.topics.each do |topic|
        topics[topic] ||= 0
        topics[topic] += 1
      end
    end

    @topics_for_select = topic_counts.keys.map{|t|[t.name.titleize, t.id]}.sort_by{|t|t[0]}.unshift(["Any", 0])

    @topic_percentages = topic_counts.each_with_object({}) { |(topic, count), percentages|
      percentages[topic.name] = (user_topic_counts[topic] || 0).to_f / count * 100
    }.to_a.sort {|t1,t2|
      # Sort by percentage completed and then topic name
      diff = t1[1] <=> t2[1]
      diff == 0 ? t1[0] <=> t2[0] : -diff
    }

    @core_track_completion_percentage = @core_exercises_and_solutions.size > 0 ? (@num_solved_core_exercises.to_f / @core_exercises_and_solutions.size * 100).round : 0
    @track_completion_percentage = exercises.size > 0 ? ((@num_solved_core_exercises + @num_solved_side_exercises).to_f / exercises.size * 100).round : 0
  end

  def show_not_joined
    @track = Track.find(params[:id])
    @mentors = @track.mentorships.reorder('rand()')
    @maintainers = @track.maintainers.visible.reorder('alumnus DESC, rand()')
    @exercises = @track.exercises.active.reorder('rand()').limit(6)
    @testimonial = @track.testimonials.order('rand()').first
    @testimonial = Testimonial.generic.order('rand()').first unless @testimonial

    render :show_not_joined
  end
end
