require_relative "./test_case"

class Research::UserSolvesSolutionTest < Research::TestCase
  test "user views previous test status" do
    stub_client = Aws::S3::Client.new(stub_responses: true)
    Aws::S3::Client.stubs(:new).returns(stub_client)
    user = create(:user, :onboarded, joined_research_at: 2.days.ago)
    solution = create(:research_experiment_solution, user: user)
    submission = create(:submission, tested: true, solution: solution)
    create(:submission_test_run,
           submission: submission,
           ops_status: 200,
           results_status: "fail",
           tests: [
             {
               "name" => "OneWordWithOneVowel",
               "status" => "pass",
             },
             {
               "name" => "OneWordWithTwoVowels",
               "status" => "fail",
               "message" => "Wrong variable",
               "output" => "1 + 1"
             }
           ]
          )

    sign_in!(user)
    visit research_experiment_solution_path(solution)
    click_on "Results"

    assert_text "Sentence.WordWithMostVowels(\"a\")"
    assert_text "Wrong variable"
    assert_text "1 + 1"
  end

  test "user views code" do
    user = create(:user, :onboarded, joined_research_at: 2.days.ago)
    solution = create(:research_experiment_solution, user: user)

    sign_in!(user)
    visit research_experiment_solution_path(solution)

    assert_text "TODO"
  end
end
