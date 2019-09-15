class CancelMentoringRequestForSolution
  include Mandate

  initialize_with :solution

  def call
    return unless solution.mentorships.size == 0

    solution.update!(
      mentoring_requested_at: nil,
      last_updated_by_user_at: Time.current,
      updated_at: Time.current
    )
  end
end

