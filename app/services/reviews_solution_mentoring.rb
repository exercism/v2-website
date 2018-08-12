class ReviewsSolutionMentoring
  def self.review!(*args)
    new(*args).review!
  end

  attr_reader :solution, :mentor_id, :rating, :feedback
  def initialize(solution, mentor_id, rating, feedback)
    @solution = solution
    @mentor_id = mentor_id
    @rating = rating
    @feedback = feedback
  end

  def review!
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
