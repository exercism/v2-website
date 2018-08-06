require 'application_system_test_case'

class My::SolutionDiscussionSectionTest < ApplicationSystemTestCase
  REQUEST_MENTORING_TEXT = "Request mentor feedback."
  COMPLETE_TEXT = "Complete this solution."
  PUBLISH_TEXT = "Publish this solution."

  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    sign_in!(@user)
  end

  test "mentored mode / mentored solution" do

    solution = create(:solution, user: @user, track_in_independent_mode: false, independent_mode: false)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    refute_selector ".completed-section"
    assert_selector ".discussion h3", text: "Mentor Discussion"
    assert_selector ".discussion form"
  end

  test "m/m section with auto approve" do
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, track_in_independent_mode: false, independent_mode: false, exercise: exercise, approved_by: create(:user))
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".next-steps"
    refute_selector ".completed-section"
    assert_selector ".discussion h3", text: "Mentor Discussion"
    refute_selector ".discussion .posts"
    refute_selector ".discussion form"
  end

  test "m/m section with auto approve and comment" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")

    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, track_in_independent_mode: false, independent_mode: false, exercise: exercise, approved_by: create(:user))
    iteration = create :iteration, solution: solution
    create :discussion_post, iteration: iteration
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".next-steps"
    refute_selector ".completed-section"
    assert_selector ".discussion h3", text: "Mentor Discussion"
    assert_selector ".discussion .posts"
    assert_selector ".discussion form"
  end

  test "m/m section completed with auto approve and comment" do
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, track_in_independent_mode: false, independent_mode: false, exercise: exercise, approved_by: create(:user), completed_at: Time.current)
    iteration = create :iteration, solution: solution
    create :discussion_post, iteration: iteration
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".completed-section .next-option strong", text: PUBLISH_TEXT
    refute_selector ".completed-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".completed-section .next-option strong", text: COMPLETE_TEXT

    refute_selector ".next-steps"
    assert_selector ".discussion h3", text: "Mentor Discussion"
    assert_selector ".discussion .posts"
    assert_selector ".discussion form"
  end

  test "m/m completed section with auto approve" do
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, track_in_independent_mode: false, independent_mode: false, exercise: exercise, approved_by: create(:user), completed_at: Time.now)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".completed-section .next-option strong", text: PUBLISH_TEXT
    refute_selector ".completed-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".completed-section .next-option strong", text: COMPLETE_TEXT

    refute_selector ".next-steps"
    assert_selector ".discussion h3", text: "Mentor Discussion"
    refute_selector ".discussion .posts"
    refute_selector ".discussion form"
  end

  test "independent mode / mentored solution" do
    solution = create(:solution, user: @user, track_in_independent_mode: true, independent_mode: false)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".discussion h3", text: "Mentor Discussion"
    assert_selector ".discussion form"
  end

  test "mentored mode / independent solution" do
    solution = create(:solution, user: @user, track_in_independent_mode: false, independent_mode: true)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".completed-section .next-option strong", text: REQUEST_MENTORING_TEXT 
    refute_selector ".discussion"
  end

  test "independent mode / independent solution" do
    solution = create(:solution, user: @user, track_in_independent_mode: true, independent_mode: true)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".completed-section .next-option strong", text: COMPLETE_TEXT
    refute_selector ".completed-section .next-option strong", text: PUBLISH_TEXT
    assert_selector ".completed-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".discussion"
  end

  test "independent mode / independent solution - completed" do
    solution = create(:solution, user: @user, track_in_independent_mode: true, independent_mode: true, completed_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    refute_selector ".completed-section .next-option strong", text: COMPLETE_TEXT
    assert_selector ".completed-section .next-option strong", text: PUBLISH_TEXT
    assert_selector ".completed-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".discussion"
  end

  test "independent mode / independent solution - published" do
    solution = create(:solution, user: @user, track_in_independent_mode: true, independent_mode: true, published_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    refute_selector ".completed-section .next-option strong", text: COMPLETE_TEXT
    refute_selector ".completed-section .next-option strong", text: PUBLISH_TEXT
    assert_selector ".completed-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".discussion"
  end
end
