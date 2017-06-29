require 'test_helper'

class CreatesMentorViewTest < ActiveSupport::TestCase
  test "creates in valid case" do
    discussion_post = create :discussion_post
    solution = discussion_post.iteration.solution
    user = solution.user
    mentor = discussion_post.user
    rating = 2
    feedback = "The foo was not enough bar"

    review = CreatesMentorReview.create(
      user, mentor, solution, rating, feedback
    )

    assert review.persisted?
    assert_equal review.user, user
    assert_equal review.mentor, mentor
    assert_equal review.solution, solution
    assert_equal review.rating, rating
    assert_equal review.feedback, feedback
  end
end

