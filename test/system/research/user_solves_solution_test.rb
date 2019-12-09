require_relative "./test_case"

class Research::UserSolvesSolutionTest < Research::TestCase
  test "user views previous test status" do
    stub_client = Aws::S3::Client.new(stub_responses: true)
    Aws::S3::Client.stubs(:new).returns(stub_client)
    user = create(:user, :onboarded, joined_research_at: 2.days.ago)
    solution = create(:research_experiment_solution, user: user)
    submission = create(:submission, solution: solution)
    create(:submission_test_run,
           submission: submission,
           results_status: "fail",
           tests: [
             {
               "name" => "OneWordWithOneVowel",
               "status" => "fail",
               "message" => "Wrong variable"
             }
           ]
          )

    sign_in!(user)
    visit research_experiment_solution_path(solution)

    assert_text "Wrong variable"
  end

  test "user views code" do
    user = create(:user, :onboarded, joined_research_at: 2.days.ago)
    solution = create(:research_experiment_solution, user: user)

    sign_in!(user)
    visit research_experiment_solution_path(solution)

    assert_text "TODO"
  end
end
