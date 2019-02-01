class RequestMentoringOnSolution
  include Mandate

  initialize_with :solution

  def call
    # We guard this for exercises that are promoted to core
    unless (user_track.mentored_mode? && solution.exercise.core?)
      return if user_track.mentoring_allowance_used_up?
    end

    solution.update(
      completed_at: nil,
      published_at: nil,
      approved_by: nil,
      last_updated_by_user_at: Time.current,
      mentoring_requested_at: Time.current,
      updated_at: Time.current
    )
  end

  private

  def user_track
    solution.user.user_track_for(solution.track)
  end
end
