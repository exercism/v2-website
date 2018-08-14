class ReviewSolutionMentoring
  include Mandate

  initialize_with :solution, :mentor_id, :rating, :feedback

  def call
    solution_mentorship.update!(
      rating: rating,
      feedback: feedback,
      show_feedback_to_mentor: false
    )
  end

  def solution_mentorship
    @solution_mentorship ||=
      solution.mentorships.where(user_id: mentor_id).first!
  end
end

