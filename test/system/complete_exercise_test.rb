require 'application_system_test_case'

class CompleteExerciseTest < ApplicationSystemTestCase
  test "unlocks only core exercises for an unapproved solution" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    exercise = create(:exercise, track: track, core: true)
    create(:exercise,
           track: track,
           title: "Core Exercise",
           core: true,
           unlocked_by: exercise)
    create(:exercise,
           track: track,
           core: false,
           unlocked_by: exercise)
    create(:user_track, track: track, user: user, independent_mode: false)
    solution = create(:solution,
                      user: user,
                      exercise: exercise)
    iteration = create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Complete exercise (Unapproved)"
    check "I understand and agree to continue."
    click_on "Mark as completed"
    click_on "Continue"
    click_on "Continue"
    click_on "Save and continue"

    assert_text "You have unlocked the following core exercise:\nCore Exercise"
    assert_no_text "You have also unlocked 1 bonus exercises"
  end

  test "unlocks core exercises and side exercises for an approved solution" do
    mentor = create(:user)
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    exercise = create(:exercise, track: track, core: true)
    create(:exercise,
           track: track,
           title: "Core Exercise",
           core: true,
           unlocked_by: exercise)
    create(:exercise,
           track: track,
           title: "Side Exercise",
           core: false,
           unlocked_by: exercise)
    create(:user_track, track: track, user: user, independent_mode: false)
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      approved_by: mentor)
    iteration = create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Complete Exercise"
    click_on "Continue"
    click_on "Continue"
    click_on "Save and continue"

    assert_text "You have unlocked the following core exercise:\nCore Exercise"
    assert_text "You have also unlocked 1 bonus exercises"
  end
end
