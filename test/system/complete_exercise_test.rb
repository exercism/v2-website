require 'application_system_test_case'

class CompleteExerciseTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::Exercise.any_instance.stubs(test_suite: [])
  end

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
                      exercise: exercise,
                      mentoring_requested_at: Time.current)
    iteration = create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Complete exercise (Unapproved)"
    check "I understand and agree to continue."
    click_on "Mark as completed"
    sleep(0.1)
    click_on "Continue"
    sleep(0.1)
    click_on "Continue"

    assert_text "You have unlocked the following Core Exercise:\nCore Exercise"
    assert_no_text "You have also unlocked 1 Side Exercises"
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
                      approved_by: mentor,
                      mentoring_requested_at: Time.current)
    iteration = create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Complete Exercise"
    sleep(0.1)
    click_on "Continue"
    sleep(0.1)
    click_on "Continue"

    assert_text "You have unlocked the following Core Exercise:\nCore Exercise"
    assert_text "You have also unlocked 1 Side Exercises"
  end

  test "can complete independent mode exercise" do
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
    create(:user_track, track: track, user: user, independent_mode: true)
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      mentoring_requested_at: Time.current)
    iteration = create(:iteration, solution: solution)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Complete exercise"
    sleep(0.1)
    click_on "Continue"
    sleep(0.1)
    click_on "Continue"

    refute_selector ".pure-button", text: "Complete exercise"
  end
end
