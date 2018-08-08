require 'application_system_test_case'

class My::SideExercisesHoverTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    Git::ExercismRepo.stubs(pages: [])

    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    @track = create :track
    @core_exercise = create :exercise, track: @track, core: true
    @side_exercise = create :exercise, track: @track, unlocked_by: @core_exercise, title: "side-1"
    @core_solution = create :solution, exercise: @core_exercise, user: @user, completed_at: Time.current

    create :user_track, user: @user, track: @track, independent_mode: false
    sign_in!(@user)
  end

  test "default state" do
    visit my_track_path(@track)
    assert_selector ".core-exercises .unlocked-exercises-section h3", text: "You've unlocked extra exercises!"
  end

  test "hover in bonus state" do
    visit my_track_path(@track)
    find(".core-exercises .unlocked-exercises a.unlocked-exercise").hover
    assert_selector ".core-exercises .unlocked-exercises-section h3", text: "side-1: Unlocked"
  end

  test "hover unlocked state" do
    @solution = create :solution, exercise: @side_exercise, user: @user
    visit my_track_path(@track)
    find(".core-exercises .unlocked-exercises a.unlocked-exercise").hover
    assert_selector ".core-exercises .unlocked-exercises-section h3", text: "side-1: Unlocked"
  end

  test "hover in progress state" do
    @solution = create :solution, exercise: @side_exercise, user: @user, downloaded_at: Time.current
    visit my_track_path(@track)
    find(".core-exercises .unlocked-exercises a.unlocked-exercise").hover
    assert_selector ".core-exercises .unlocked-exercises-section h3", text: "side-1: In progress"
  end

  test "hover in approved state" do
    @solution = create :solution, exercise: @side_exercise, user: @user, approved_by: create(:user)
    visit my_track_path(@track)
    find(".core-exercises .unlocked-exercises a.unlocked-exercise").hover
    assert_selector ".core-exercises .unlocked-exercises-section h3", text: "side-1: Approved"
  end

  test "hover in completed state" do
    # We need this else the "completed" state of the track kicks in
    create :exercise, track: @track, core: true
    @solution = create :solution, exercise: @side_exercise, user: @user, completed_at: Time.current
    visit my_track_path(@track)
    find(".core-exercises .unlocked-exercises a.unlocked-exercise").hover
    assert_selector ".core-exercises .unlocked-exercises-section h3", text: "side-1: Completed"
  end


end
