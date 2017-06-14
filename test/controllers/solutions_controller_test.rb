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
end
