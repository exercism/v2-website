require 'test_helper'

class My::IterationsControllerTest < ActionDispatch::IntegrationTest
  test "redirects to the correct iteration index" do
    user = create(:user, :onboarded)
    solution = create(:solution, user: user)
    iteration = create(:iteration, solution: solution)
    iteration2 = create(:iteration, solution: solution)

    sign_in!(user)
    get my_solution_iteration_path(solution, iteration)

    assert_redirected_to my_solution_path(solution, iteration_idx: 1)
  end
end
