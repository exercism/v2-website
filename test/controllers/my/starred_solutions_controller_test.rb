require 'test_helper'

class My::StarredSolutionsControllerTest < ActionDispatch::IntegrationTest
  test "create creates" do
    sign_in!
    solution = create :solution, published_at: DateTime.now
    post my_starred_solutions_path, params: {solution_id: solution.uuid, format: 'js'}

    assert_response :success
    assert_equal 1, solution.stars.size
    solution_star = solution.stars.first

    assert_equal @current_user, solution_star.user
  end

  test "create destroys" do
    sign_in!
    solution = create :solution, published_at: DateTime.now
    solution_star = create :solution_star, solution: solution, user: @current_user
    post my_starred_solutions_path, params: {solution_id: solution.uuid, format: 'js'}

    assert_response :success
    assert_equal 0, SolutionStar.where(solution: solution).size
  end

  test "index only shows published solutions" do
    sign_in!
    published_solution = create :solution, published_at: DateTime.now
    unpublished_solution = create :solution
    create :solution_star, solution: published_solution, user: @current_user
    create :solution_star, solution: unpublished_solution, user: @current_user

    get my_starred_solutions_path
    assert_equal [published_solution], assigns(:solutions)
  end
end
