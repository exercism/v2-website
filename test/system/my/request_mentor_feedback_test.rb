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
end
