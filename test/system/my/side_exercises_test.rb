require 'application_system_test_case'

class My::SideExercisesTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::ExercismRepo.stubs(pages: [])

    @user = create(:user, :onboarded)
    @track = create :track
    @exercise = create :exercise, track: @track, core: false
    @solution = create :solution, exercise: @exercise, user: @user

    create :user_track, user: @user, track: @track, independent_mode: false
    sign_in!(@user)
  end

  test "completed" do
    @solution.update(completed_at: Time.current)

    visit my_track_path(@track)
    click_on "Continue"
    assert_selector ".pure-u-1 .widget-side-exercise.completed"
  end

  test "approved" do
    @solution.update(approved_by: create(:user))

    visit my_track_path(@track)
    assert_selector ".pure-u-1 .widget-side-exercise.approved"
  end

  test "downloaded" do
    @solution.update(downloaded_at: Time.current)

    visit my_track_path(@track)
    assert_selector ".pure-u-1 .widget-side-exercise.in-progress"
  end

  test "iterated" do
    @solution.iterations.create

    visit my_track_path(@track)
    assert_selector ".pure-u-1 .widget-side-exercise.in-progress"
  end

  test "mentoring requested" do
    @solution.iterations.create
    @solution.update(mentoring_requested_at: Time.current)

    visit my_track_path(@track)
    assert_selector ".pure-u-lg-1-3 .widget-side-exercise.mentoring-requested"
  end

  test "unlocked" do
    visit my_track_path(@track)
    assert_selector ".pure-u-1 .widget-side-exercise.unlocked"
  end

  test "bonus" do
    @solution.destroy

    visit my_track_path(@track)
    assert_selector ".pure-u-1 a.widget-side-exercise.unlocked"
  end

  test "locked" do
    @solution.destroy
    @exercise.update(unlocked_by: create(:exercise))

    visit my_track_path(@track)
    assert_selector ".pure-u-1 .widget-side-exercise.locked"
  end
end
