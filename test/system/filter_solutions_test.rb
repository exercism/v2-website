require 'application_system_test_case'

class FilterSolutionsTest < ApplicationSystemTestCase
  test "filters solutions by status" do
    track = create(:track)
    mentor = create(:user, mentored_tracks: [track])
    hello_world = create(:exercise, track: track)
    solution = create(:solution,
                      exercise: hello_world,
                      completed_at: Date.new(2016, 12, 25))
    create(:iteration, solution: solution)
    create(:solution_mentorship,
           user: mentor,
           solution: solution,
           abandoned: false,
           requires_action: false)

    sign_in!(mentor)
    visit mentor_dashboard_path
    select_option "Completed", id: :status

    assert page.has_link?(href: mentor_solution_path(solution))
  end

  test "displays solutions requiring action by default" do
    track = create(:track)
    mentor = create(:user, mentored_tracks: [track])
    hello_world = create(:exercise, track: track)
    action_required_solution = create(:solution,
                                      exercise: hello_world)
    completed_solution = create(:solution,
                                exercise: hello_world,
                                completed_at: Date.new(2016, 12, 25))
    create(:iteration, solution: action_required_solution)
    create(:iteration, solution: completed_solution)
    create(:solution_mentorship,
           user: mentor,
           solution: action_required_solution,
           abandoned: false,
           requires_action: true)
    create(:solution_mentorship,
           user: mentor,
           solution: completed_solution,
           abandoned: false,
           requires_action: false)

    sign_in!(mentor)
    visit mentor_dashboard_path

    assert page.has_link?(href: mentor_solution_path(action_required_solution))
    assert page.has_no_link?(href: mentor_solution_path(completed_solution))
  end

  test "filters solutions by track" do
    ruby = create(:track, title: "Ruby")
    cpp = create(:track, title: "C++")
    mentor = create(:user, mentored_tracks: [ruby, cpp])
    hello_world_ruby = create(:exercise, track: ruby)
    solution_ruby = create(:solution, exercise: hello_world_ruby)
    hello_world_cpp = create(:exercise, track: cpp)
    solution_cpp = create(:solution, exercise: hello_world_cpp)
    create(:iteration, solution: solution_ruby)
    create(:solution_mentorship,
           user: mentor,
           solution: solution_ruby,
           requires_action: true)
    create(:iteration, solution: solution_cpp)
    create(:solution_mentorship,
           user: mentor,
           solution: solution_cpp,
           requires_action: true)

    sign_in!(mentor)
    visit mentor_dashboard_path
    select_option "Ruby", id: :track_id

    assert page.has_link?(href: mentor_solution_path(solution_ruby))
    assert page.has_no_link?(href: mentor_solution_path(solution_cpp))
  end

  test "filters solutions by exercise" do
    ruby = create(:track, title: "Ruby")
    mentor = create(:user, mentored_tracks: [ruby])
    hello_world = create(:exercise, title: "Hello World", track: ruby)
    sorting = create(:exercise, title: "Sorting", track: ruby)
    hello_world_solution = create(:solution, exercise: hello_world)
    create(:iteration, solution: hello_world_solution)
    create(:solution_mentorship,
           user: mentor,
           solution: hello_world_solution,
           requires_action: true)
    sorting_solution = create(:solution, exercise: sorting)
    create(:iteration, solution: sorting_solution)
    create(:solution_mentorship,
           user: mentor,
           solution: sorting_solution,
           requires_action: true)

    sign_in!(mentor)
    visit mentor_dashboard_path
    select_option "Ruby", id: :track_id
    select_option "Sorting", id: :exercise_id

    assert page.has_link?(href: mentor_solution_path(sorting_solution))
    assert page.has_no_link?(href: mentor_solution_path(hello_world_solution))
  end
end
