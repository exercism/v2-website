require "application_system_test_case"

class SolutionLocksTest < ApplicationSystemTestCase
  setup do
    @mentor = create(:user)
    @track = create(:track, title: "Ruby")
    create :track_mentorship, user: @mentor, track: @track

    @solution = create :solution, exercise: create(:exercise, track: @track)
    create :iteration, solution: @solution

    sign_in!(@mentor)
  end

  test "shows discussion if the user is mentoring" do
    create :solution_mentorship, solution: @solution, user: @mentor

    visit mentor_solution_path(@solution)

    assert_selector ".discussion"
    refute_selector ".claim-section"
  end

  test "shows discussion if the user has a lock" do
    create :solution_lock, solution: @solution, user: @mentor, locked_until: Time.current + 1.minute

    visit mentor_solution_path(@solution)

    assert_selector ".discussion"
    refute_selector ".claim-section"
  end

  test "shows claim-section otherwise" do
    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    refute_selector ".discussion"

    click_on "Mentor this solution"
    assert_selector ".discussion"
    refute_selector ".claim-section"
  end

  test "check force works" do
    create :solution_lock, solution: @solution, user: create(:user), locked_until: Time.current + 1.minute

    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    refute_selector ".discussion"

    click_on "Mentor this solution"
    assert_selector ".claim-section"
    refute_selector ".discussion"

    click_on "Mentor this solution anyway"
    assert_selector ".discussion"
    refute_selector ".claim-section"
  end
end
