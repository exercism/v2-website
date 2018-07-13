require 'test_helper'

class My::IterationsControllerTest < ActionDispatch::IntegrationTest
  test "redirects to the correct iteration index" do
    user = create(:user, accepted_terms_at: Date.new(2016, 12, 25), accepted_privacy_policy_at: Date.new(2016, 12, 25))
    solution = create(:solution, user: user)
    iteration = create(:iteration, solution: solution)
    iteration2 = create(:iteration, solution: solution)

    sign_in!(user)
    get my_solution_iteration_path(solution, iteration)

    assert_redirected_to my_solution_path(solution, iteration_idx: 1)
  end
end
