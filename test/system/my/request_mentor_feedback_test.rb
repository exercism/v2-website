require 'application_system_test_case'

class My::RequestMentorFeedbackTest < ApplicationSystemTestCase
  test "requests mentor feedback for an auto approved solution" do
    system = create(:user, :system)
    user = create(:user, :onboarded)
    solution = create(:solution, user: user, approved_by: system)
    create(:iteration, solution: solution)
    create(:user_track, track: solution.track, user: user)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Request mentor feedback"

    assert_text "The student has requested a mentor reviews this solution."
  end

  test "requests mentor feedback in indepedent mode" do
    create(:user, :system)
    user = create(:user, :onboarded)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user, independent_mode: true)
    solution = create(:solution, user: user, exercise: exercise)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Request mentor feedback"

    assert_text "You have requested mentoring for this exercise"
  end

  test "requests mentor feedback on a side exercise in mentored mode" do
    create(:user, :system)
    user = create(:user, :onboarded)
    track = create(:track)
    exercise = create(:exercise, track: track, core: false)
    create(:user_track, track: track, user: user)
    solution = create(:solution, user: user, exercise: exercise)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Request mentor feedback"

    assert_text "You have requested mentoring for this exercise"
  end

  test "requests mentor feedback in legacy mode" do
    create(:user, :system)
    user = create(:user, :onboarded)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user)
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      last_updated_by_user_at: Exercism::V2_MIGRATED_AT)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Request mentor feedback"

    assert_text "A mentor will leave you feedback as soon as possible"
  end

  test "requests mentor feedback in indepedent mode via notification bar" do
    create(:user, :system)
    user = create(:user, :onboarded)
    track = create(:track)
    exercise = create(:exercise, track: track, core: true)
    create(:user_track, track: track, user: user, independent_mode: true)
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      track_in_independent_mode: true)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Request mentoring"

    assert_text "You have requested mentoring for this exercise"
  end
end
