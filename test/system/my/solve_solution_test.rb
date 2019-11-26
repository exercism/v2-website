require "application_system_test_case"

class My::SolveSolutionTest < ApplicationSystemTestCase
  test "user views submission status" do
    admin = create(:user, :onboarded, admin: true)
    solution = create(:solution, user: admin)
    create(:submission, solution: solution)

    sign_in!(admin)
    visit solve_my_solution_path(solution)

    assert_text "Ops Status: Queued"
  end
end
