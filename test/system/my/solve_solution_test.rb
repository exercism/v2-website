require "application_system_test_case"

class My::SolveSolutionTest < ApplicationSystemTestCase
  test "user views submission status" do
    admin = create(:user, :onboarded, admin: true)
    solution = create(:solution, user: admin)
    create(:submission, solution: solution)

    sign_in!(admin)
    visit solve_my_solution_path(solution)

    assert_text "Status: Queued"
  end

  test "user views test status" do
    admin = create(:user, :onboarded, admin: true)
    solution = create(:solution, user: admin)
    submission = create(:submission, solution: solution)
    create(:submission_test_result,
           submission: submission,
           results_status: "fail",
           tests: [
             {
               "name" => "Test 1",
               "status" => "fail",
               message: "Wrong variable"
             }
           ]
          )

    sign_in!(admin)
    visit solve_my_solution_path(solution)

    assert_text "Status: Failed"
    assert_text "Failed test: Test 1"
    assert_text "Wrong variable"
  end
end
