require 'application_system_test_case'

class DashboardTest < ApplicationSystemTestCase
  test "displays the number of days ago a solution was updated in days, not months" do
    some_date = Date.new(2019, 1, 1)
    solution_updated_at = Time.now - 33.days

    track = create(:track)
    mentor = create(:user_mentor,
                    accepted_terms_at: some_date,
                    accepted_privacy_policy_at: some_date,
                    mentored_tracks: [track])
    exercise = create(:exercise, title: "Exercise 1", track: track)
    solution = create(:solution, exercise: exercise,
                mentoring_requested_at: solution_updated_at,
                last_updated_by_user_at: solution_updated_at)
    create(:iteration, solution: solution)
    create(:solution_mentorship,
           user: mentor,
           solution: solution,
           requires_action_since: solution_updated_at)

    sign_in!(mentor)
    visit mentor_dashboard_path

    assert page.has_content?('33 days ago')
  end
end
