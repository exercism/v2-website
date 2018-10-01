require 'application_system_test_case'

class CompleteSolutionTest < ApplicationSystemTestCase
  test "completes a solution" do
    Git::ExercismRepo.stubs(current_head: SecureRandom.uuid)
    Git::ExercismRepo.stubs(pages: [])

    track = create(:track)
    user = create(:user)
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    mentor = create(:user, mentored_tracks: [track])
    user_track = create(:user_track,
                        user: user,
                        track: track,
                        independent_mode: false)
    exercise = create(:exercise, track: track, title: "Hello World")
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      approved_by: mentor,
                      mentoring_requested_at: Time.current)
    create(:iteration, solution: solution)
    solution_mentorship = create(:solution_mentorship,
                                 solution: solution,
                                 user: mentor)

    create(:exercise, unlocked_by: exercise, track: exercise.track)

    sign_in!(user)
    visit my_solution_path(solution.uuid)

    click_link "Complete exercise"
    assert page.has_content?("You've completed Hello World")

    click_link "Continue"
    check "Publish my solution"
    fill_in "reflection", with: "Printing to the console was easy!"
    click_button "Continue"
    find("label[for=mentor_reviews_#{mentor.id}_rating_5]").click
    click_button "Save and continue"
    click_link "Continue"

    solution.reload
    assert_equal "Printing to the console was easy!", solution.reflection
    assert solution.published?
    solution_mentorship.reload
    assert_equal 5, solution_mentorship.rating
  end
end
