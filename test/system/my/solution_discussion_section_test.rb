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

  test "mentored mode / mentoring_requested" do
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current, exercise: create(:exercise, core: true))
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".discussion h3", text: "Mentor discussion"
    assert_selector ".discussion form"

    assert_selector ".next-steps"
    assert_selector ".next-steps a", text: "other Exercism tracks"

    refute_selector ".finished-section"
  end

  test "mentored mode / side solution" do
    solution = create(:solution, user: @user, mentoring_requested_at: nil, exercise: create(:exercise, core: false))
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    assert_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    assert_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT

    refute_selector ".discussion"
  end

  test "mentored mode / side solution with mentoring requested" do
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current, exercise: create(:exercise, core: false))
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".discussion h3", text: "Mentor discussion"
    assert_selector ".discussion form"

    assert_selector ".next-steps"
    assert_selector ".next-steps a", text: "other people have solved this"

    refute_selector ".finished-section"
  end

  test "mentored section with auto approve" do
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current, exercise: exercise, approved_by: create(:user))
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".next-steps"
    assert_selector ".next-steps a", text: "Complete exercise"

    assert_selector ".discussion h3", text: "Mentor discussion"
    refute_selector ".discussion .posts"
    refute_selector ".discussion form"

    refute_selector ".finished-section"
  end

  test "mentored section with auto approve and comment" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")

    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current, exercise: exercise, approved_by: create(:user))
    iteration = create :iteration, solution: solution
    create :discussion_post, iteration: iteration
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".next-steps"
    refute_selector ".finished-section"
    assert_selector ".discussion h3", text: "Mentor discussion"
    assert_selector ".discussion .posts"
    assert_selector ".discussion form"
  end

  test "mentored section completed with auto approve and comment" do
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current, exercise: exercise, approved_by: create(:user), completed_at: Time.current)
    iteration = create :iteration, solution: solution
    create :discussion_post, iteration: iteration
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert ".finished-section .next-option strong", text: PUBLISH_TEXT
    refute_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".finished-section .next-option strong", text: COMPLETE_TEXT

    refute_selector ".next-steps"
    assert_selector ".discussion h3", text: "Mentor discussion"
    assert_selector ".discussion .posts"
    assert_selector ".discussion form"
  end

  test "mentored section completed with auto approve" do
    exercise = create :exercise, auto_approve: true
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current, exercise: exercise, approved_by: create(:user), completed_at: Time.now)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".finished-section .next-option strong", text: PUBLISH_TEXT
    refute_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".finished-section .next-option strong", text: COMPLETE_TEXT

    refute_selector ".next-steps"
    assert_selector ".discussion h3", text: "Mentor discussion"
    refute_selector ".discussion .posts"
    refute_selector ".discussion form"
  end

  test "independent mode - requested mentoring" do
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user, independent_mode: true)

    visit my_solution_path(solution)

    assert_selector ".discussion h3", text: "Mentor discussion"
    assert_selector ".discussion form"
  end

  test "independent mode / not requested mentoring" do
    solution = create(:solution, user: @user, mentoring_requested_at: nil)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user, independent_mode: true)

    visit my_solution_path(solution)

    assert_selector ".finished-section .next-option strong", text: COMPLETE_TEXT
    refute_selector ".finished-section .next-option strong", text: PUBLISH_TEXT
    assert_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".discussion"
  end

  test "independent mode / not requested mentoring - completed" do
    solution = create(:solution, user: @user, mentoring_requested_at: nil, completed_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user, independent_mode: true)

    visit my_solution_path(solution)

    refute_selector ".finished-section .next-option strong", text: COMPLETE_TEXT
    assert_selector ".finished-section .next-option strong", text: PUBLISH_TEXT
    assert_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".discussion"
  end

  test "independent mode / not requested mentoring - published" do
    solution = create(:solution, user: @user, mentoring_requested_at: nil, published_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user, independent_mode: true)

    visit my_solution_path(solution)

    refute_selector ".finished-section .next-option strong", text: COMPLETE_TEXT
    refute_selector ".finished-section .next-option strong", text: PUBLISH_TEXT
    assert_selector ".finished-section .next-option strong", text: REQUEST_MENTORING_TEXT
    refute_selector ".discussion"
  end

  test "comment button clears preview tab" do
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".comment-button"
    assert_selector ".markdown"
    refute_selector ".preview"

    find(".new-discussion-post-form textarea").set("An example mentor comment to test the comment button!")
    find(".preview-tab").click
    within(".preview-area") { assert_text "An example mentor comment to test the comment button!" }
    click_on "Comment"
    within(".preview-area") { assert_text "", { exact: true } }
  end

  test "localstorage saves comment draft" do
    solution = create(:solution, user: @user, mentoring_requested_at: Time.current)
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".comment-button"
    assert_selector ".markdown"
    refute_selector ".preview"

    assert_equal "", find(".new-discussion-post-form textarea").value
    find(".new-discussion-post-form textarea").set("An example mentor comment to test the comment button!")

    visit my_solution_path(solution)

    assert_equal "An example mentor comment to test the comment button!", find(".new-discussion-post-form textarea").value
    find(".new-discussion-post-form textarea").set("")

    visit my_solution_path(solution)

    assert_equal "", find(".new-discussion-post-form textarea").value
  end
end
