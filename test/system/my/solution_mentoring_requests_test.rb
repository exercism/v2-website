require 'application_system_test_case'

class My::SolutionDiscussionSectionTest < ApplicationSystemTestCase

  REQUEST_MENTORING_TEXT = "Request mentor feedback."

  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    sign_in!(@user)
  end

  test "mentored mode / side solution with mentoring requested" do
    solution = create(:solution, user: @user, mentoring_requested_at: nil, exercise: create(:exercise, core: false))
    create :iteration, solution: solution
    create(:user_track, track: solution.track, user: @user)

    visit my_solution_path(solution)

    assert_selector ".discussion h3", text: "Mentor discussion"
    assert_selector ".discussion form"

    assert_selector ".next-steps"
    assert_selector ".next-steps a", text: "other people have solved this"

    refute_selector ".finished-section"
  end

