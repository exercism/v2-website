require 'application_system_test_case'

class ExerciseTest < ApplicationSystemTestCase
  test "shows exercises" do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    user = create(:user)
    track = create(:track)
    create(:user_track, user: user, track: track, independent_mode: false)
    in_progress_exercise = create(:exercise,
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
           exercise: in_progress_exercise)
    create(:solution,
           user: user,
           completed_at: Date.new(2016, 12, 25),
           exercise: completed_exercise)

    sign_in!(user)
    visit my_track_path(track)

    within(".exercise.completed") { assert_text "Strings" }
    within(".exercise.in-progress") { assert_text "Hello World" }
    within(".exercise.locked") { assert_text "Locked" }
  end
end
