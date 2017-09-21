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
end
