class Mentor::DashboardController < MentorController
  def show
    @status = params[:status]
    @status_options = SolutionMentorship::STATUSES

    @track_id = params[:track_id]
    @track_id_options = OptionsHelper.as_options(current_user.mentored_tracks,
                                                 :title,
                                                 :id)

    @exercise_id = params[:exercise_id]
    @exercise_id_options = exercise_id_options

    @your_solutions = RetrievesSolutionsForMentor.retrieve(
      current_user,
      status: @status,
      track_id: @track_id,
      exercise_id: @exercise_id
    ).to_a
    @suggested_solutions = SelectSuggestedSolutionsForMentor.(current_user, params[:page]).to_a

    user_ids = @your_solutions.pluck(:user_id) + @suggested_solutions.pluck(:user_id)
    @user_tracks = UserTrack.where(user_id: user_ids).
                             each_with_object({}) { |ut, h| h["#{ut.user_id}|#{ut.track_id}"] = ut }

    @total_solutions_count = current_user.solution_mentorships.count
    @total_students_count = current_user.solution_mentorships.select(:user_id).distinct.count
    @weekly_solutions_count = current_user.solution_mentorships.where("solution_mentorships.created_at > ?", Time.now.beginning_of_week).count
    @feedbacks = current_user.solution_mentorships.where(show_feedback_to_mentor: true).order('updated_at desc').limit(5).pluck(:feedback)
  end

  private

  def exercise_id_options
    track = Track.find_by(id: @track_id)
    return [] unless track

    OptionsHelper.as_options(track.exercises, :title, :id)
  end
end

