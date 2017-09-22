class Mentor::DashboardController < MentorController
  def show
    @status = params[:status]
    @status_options = SolutionMentorship::STATUSES
    @track_id = params[:track_id]
    @track_id_options = current_user.
      mentored_tracks.
      map { |track| [track.title, track.id] }
    @exercise_id = params[:exercise_id]
    @track = Track.find_by(id: @track_id)
    @exercise_id_options = if @track
                             @track.
                               exercises.
                               map do |exercise|
                                 { text: exercise.title, value: exercise.id }
                               end
                           else
                             []
                           end

    @your_solutions = RetrievesSolutionsForMentor.retrieve(
      current_user,
      status: @status,
      track_id: @track_id,
      exercise_id: @exercise_id
    )
    @suggested_solutions = SelectsSuggestedSolutionsForMentor.select(current_user, params[:page])

    user_ids = @your_solutions.pluck(:user_id) + @suggested_solutions.pluck(:user_id)
    @user_tracks = UserTrack.where(user_id: user_ids).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }

    @total_solutions_count = current_user.mentored_solutions.count
    @total_students_count = current_user.mentored_solutions.select(:user_id).distinct.count
    @feedbacks = current_user.solution_mentorships.where(show_feedback_to_mentor: true).order('updated_at desc').limit(5).pluck(:feedback)
  end
end

