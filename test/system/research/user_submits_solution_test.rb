require_relative "./test_case"

class Research::UserSubmitsSolutionTest < Research::TestCase
  test "user submits solution" do
    stub_client = Aws::S3::Client.new(stub_responses: true)
    Aws::S3::Client.stubs(:new).returns(stub_client)
    user = create(:user, :onboarded, joined_research_at: 2.days.ago)
    experiment = create(:research_experiment)
    user_experiment = create(:research_user_experiment,
                             user: user,
                             experiment: experiment)
    track = create(:track, :research, slug: "ruby")
    exercise = create(:exercise, track: track, slug: "ruby-1-b")
    solution = create(:research_experiment_solution,
                      exercise: exercise,
                      user: user,
                      experiment: experiment)
    submission = create(:submission, tested: true, solution: solution)
    create(:submission_test_run,
           submission: submission,
           ops_status: 200,
           results_status: "pass")

    sign_in!(user)
    visit research_experiment_solution_path(solution)
    find(:css, '.tab .fa-terminal').click
    click_button "Submit exercise"
    click_button "Submit to researchers"

    assert_text "Completed"

    assert solution.reload.finished?
    assert_equal 3, solution.reload.difficulty_rating

    # This is currently not implement
    # assert_button "Start part 2"
  end
end
