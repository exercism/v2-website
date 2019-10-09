class MentorFeedbackRequest
  attr_reader :solution
  attr_accessor :status

  delegate(
    :track_max_mentoring_slots,
    :track_mentoring_slots_remaining,
    to: :solution
  )

  def initialize(solution, status: nil)
    @solution = solution
    @status = status || solution_status
  end

  def can_be_accommodated?
    [:mentoring_slots_remaining, :promoted_to_core].include?(status)
  end

  private
  delegate :user_track, to: :solution

  def solution_status
    return :oversubscribed unless solution.track_accepting_new_students?

    if solution.exercise_is_core? &&
        user_track.mentored_mode? &&
        !solution.last_updated_legacy?
      return :promoted_to_core
    end

    if user_track.mentoring_slots_remaining?
      :mentoring_slots_remaining
    else
      :mentoring_slots_used
    end
  end
end
