require 'test_helper'

class ReviewsSolutionMentoringTest < ActiveSupport::TestCase
  test "reviews in valid case" do
    solution_mentorship = create :solution_mentorship
    solution = solution_mentorship.solution
    mentor = solution_mentorship.user

    rating = 2
    feedback = "The foo was not enough bar"

    ReviewsSolutionMentoring.review!(
      solution, mentor.id, rating, feedback
    )

    solution_mentorship.reload
    assert_equal solution_mentorship.rating, rating
    assert_equal solution_mentorship.feedback, feedback
    refute solution_mentorship.show_feedback_to_mentor
  end
end
