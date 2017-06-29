require 'test_helper'

class SolutionsControllerTest < ActionDispatch::IntegrationTest
  {
    unlocked: "solution-unlocked-page",
    cloned: "solution-cloned-page"
  }.each do |status, page|
    test "shows with status #{status}" do
      sign_in!
      solution = create :solution, user: @current_user, status: status

      get solution_url(solution)
      assert_response :success
      assert_correct_page page
    end
  end

  {
    iterating: "solution-iterating-page",
    completed_approved: "solution-completed-page",
    completed_unapproved: "solution-completed-page"
  }.each do |status, page|
    test "shows with status #{status}" do
      sign_in!
      solution = create :solution, user: @current_user, status: status
      iteration = create :iteration, solution: solution

      get solution_url(solution)
      assert_response :success
      assert_correct_page page
    end
  end

  test "reflects properly" do
    sign_in!
    solution = create :solution, user: @current_user
    iteration = create :iteration, solution: solution
    discussion_post_1 = create :discussion_post, iteration: iteration
    discussion_post_2 = create :discussion_post, iteration: iteration
    discussion_post_3 = create :discussion_post, iteration: iteration
    notes = "foobar!!!"

    patch reflect_solution_url(solution), params: {
      notes: notes,
      mentor_reviews: {
        discussion_post_1.user_id => { rating: 3, review: "asdasd" },
        discussion_post_3.user_id => { rating: 2, review: "asdaqweqwewqewq" }
      }
    }

    assert_response :success

    solution.reload
    assert_equal solution.notes, notes
    assert_equal 2, MentorReview.count
  end
end
