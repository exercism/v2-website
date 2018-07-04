require 'application_system_test_case'

class ExerciseTest < ApplicationSystemTestCase
  test "shows exercises in order" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    user = create(:user)
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

    exercises = find_all(".exercise")

    assert_equal "exercise completed", exercises[0][:class]
    assert_equal "exercise in-progress", exercises[1][:class]
    assert_equal "exercise locked", exercises[2][:class]
    within(".exercise.completed") { assert_text "Strings" }
    within(".exercise.in-progress") { assert_text "Hello World" }
    within(".exercise.locked") { assert_text "Locked" }
  end
end
