require "application_system_test_case"

class SolutionLocksTest < ApplicationSystemTestCase
  setup do
    @mentor = create(:user_mentor)
    @track = create(:track, title: "Ruby")
    create :track_mentorship, user: @mentor, track: @track

    @solution = create :solution, exercise: create(:exercise, track: @track)
    @iteration = create :iteration, solution: @solution

    sign_in!(@mentor)
  end

  test "shows discussion if the user is mentoring" do
    create :solution_mentorship, solution: @solution, user: @mentor

    visit mentor_solution_path(@solution)

    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"
  end

  test "shows discussion if the user has a lock" do
    create :solution_lock, solution: @solution, user: @mentor, locked_until: Time.current + 1.minute

    visit mentor_solution_path(@solution)

    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"
  end

  test "shows claim-section if no lock" do
    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    refute_selector ".discussion"
    refute_selector ".new-discussion-post"

    click_on "Mentor this solution"
    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"
  end

  test "shows claim-section and discussions but no form if no lock but posts" do
    create :discussion_post, iteration: @iteration
    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    assert_selector ".discussion"
    refute_selector ".new-discussion-post"

    click_on "Mentor this solution"
    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"
  end

  test "check force works" do
    create :solution_lock, solution: @solution, user: create(:user), locked_until: Time.current + 1.minute

    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    refute_selector ".discussion"
    refute_selector ".new-discussion-post"

    click_on "Mentor this solution"
    assert_selector ".claim-section"
    refute_selector ".discussion"
    refute_selector ".new-discussion-post"

    click_on "Mentor this solution anyway"
    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"
  end

  test "mentor can leave solution without adding a comment" do
    visit mentor_dashboard_path
    assert page.has_link?(nil, {href: mentor_solution_path(@solution)})

    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    refute_selector ".discussion"
    refute_selector ".new-discussion-post"

    click_on "Mentor this solution"
    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"

    click_on "Leave conversation"
    assert page.has_content?("Mentor dashboard")
    assert page.has_no_link?(nil, {href: mentor_solution_path(@solution)})
  end

  test "mentor can leave solution after adding a comment" do
    visit mentor_dashboard_path
    assert page.has_link?(nil, {href: mentor_solution_path(@solution)})

    visit mentor_solution_path(@solution)

    assert_selector ".claim-section"
    refute_selector ".discussion"
    refute_selector ".new-discussion-post"

    click_on "Mentor this solution"
    assert_selector ".discussion"
    assert_selector ".new-discussion-post"
    refute_selector ".claim-section"

    find(".new-discussion-post-form textarea").set("An example mentor comment to test the comment button!")
    click_on "Comment"

    click_on "Leave conversation"
    assert page.has_content?("Mentor dashboard")
    assert page.has_no_link?(nil, {href: mentor_solution_path(@solution)})
  end
end
