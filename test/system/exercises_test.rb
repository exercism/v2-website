require 'application_system_test_case'

class ExerciseTest < ApplicationSystemTestCase
  test "shows exercises in order" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::ExercismRepo.stubs(pages: [])

    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, user: user, track: track, independent_mode: false)
    unlocked_exercise = create(:exercise,
                                  track: track,
                                  title: "Hello World",
                                  core: true)
    completed_exercise = create(:exercise,
                                track: track,
                                title: "Strings",
                                core: true)
    locked_exercise = create(:exercise,
                             track: track,
                             title: "Locked",
                             core: true)
    create(:solution,
           user: user,
           completed_at: nil,
           exercise: unlocked_exercise)
    create(:solution,
           user: user,
           completed_at: Date.new(2016, 12, 25),
           exercise: completed_exercise)

    sign_in!(user)
    visit my_track_path(track)

    exercises = find_all(".exercise-wrapper")

    assert_equal "exercise-wrapper completed", exercises[0][:class]
    assert_equal "exercise-wrapper in-progress", exercises[1][:class]
    assert_equal "exercise-wrapper locked", exercises[2][:class]
    within(".exercise-wrapper.completed") { assert_text "Strings" }
    within(".exercise-wrapper.in-progress") { assert_text "Hello World" }
    within(".exercise-wrapper.locked") { assert_text "Locked" }
  end

  test "shows unlocked exercises for an exercise" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    create(:user_track, user: user, track: track, independent_mode: false)
    exercise = create(:exercise, track: track, core: true)
    side_exercise = create(:exercise,
                           track: track,
                           unlocked_by: exercise,
                           core: false)
    create(:solution,
           user: user,
           completed_at: Date.new(2016, 12, 25),
           exercise: exercise)
    unlocked_exercise_solution = create(:solution,
                                        user: user,
                                        completed_at: nil,
                                        exercise: side_exercise)

    with_bullet do
      sign_in!(user)
      visit my_track_path(track)
    end

    assert_text "You've unlocked extra exercises"
    assert_link nil, href: my_solution_path(unlocked_exercise_solution)
  end
end
