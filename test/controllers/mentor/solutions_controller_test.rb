require 'test_helper'

class Mentor::SolutionsControllerTest < ActionDispatch::IntegrationTest
  test "approve calls service" do
    mentor = create :user_mentor
    track = create :track
    exercise = create :exercise, track: track
    create :track_mentorship, user: mentor, track: track
    solution = create :solution, exercise: exercise

    sign_in!(mentor)

    ApproveSolution.expects(:call).with(solution, mentor)
    patch approve_mentor_solution_url(solution), as: :js
    assert_response :success
  end

  test "show clears notifications" do
    mentor = create :user_mentor
    track = create :track
    exercise = create :exercise, track: track
    create :track_mentorship, user: mentor, track: track
    solution = create :solution, exercise: exercise
    iteration = create :iteration, solution: solution

    sign_in!(mentor)

    ClearNotifications.expects(:call).with(mentor, solution)
    ClearNotifications.expects(:call).with(mentor, iteration)

    get mentor_solution_url(solution)
    assert_response :success
  end

  test "abandon works without solution mentorship" do
    mentor = create :user_mentor
    track = create :track
    exercise = create :exercise, track: track
    create :track_mentorship, user: mentor, track: track
    solution = create :solution, exercise: exercise

    sign_in!(mentor)

    AbandonSolutionMentorship.expects(:call).with(mentor, solution)
    patch abandon_mentor_solution_url(solution), as: :js
    assert SolutionMentorship.where(solution: solution, user: mentor).exists?
    assert_redirected_to mentor_dashboard_path
  end

  test "abandon works with solution mentorship" do
    mentor = create :user_mentor
    track = create :track
    exercise = create :exercise, track: track
    create :track_mentorship, user: mentor, track: track
    solution = create :solution, exercise: exercise
    create :solution_mentorship, solution: solution, user: mentor

    sign_in!(mentor)

    AbandonSolutionMentorship.expects(:call).with(mentor, solution)
    patch abandon_mentor_solution_url(solution), as: :js
    assert_redirected_to mentor_dashboard_path
  end

end
