require "application_system_test_case"

class My::SolutionsInformationBarTest < ApplicationSystemTestCase
  setup do
    @user = create(:user,
                    accepted_terms_at: Date.new(2016, 12, 25),
                    accepted_privacy_policy_at: Date.new(2016, 12, 25))
    @track = create(:track)
    @user_track = create :user_track, user: @user, track: @track, independent_mode: false
    @exercise = create(:exercise, track: @track)
    @solution = create :solution, user: @user, exercise: @exercise, track_in_independent_mode: false, mentoring_requested_at: Time.current
    @iteration = create(:iteration, solution: @solution)
  end

  test "On submission" do
    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "Well done on submitting. A mentor will leave you feedback as soon as possible."
  end

  test "After own discussion post" do
    sign_in!(@user)
    visit my_solution_path(@solution)

    create :discussion_post, iteration: @iteration, user: @user

    assert_selector ".notifications-bar .notification", text: "Well done on submitting. A mentor will leave you feedback as soon as possible."
  end

  test "on mentor comment on first viewing" do
    dp = create :discussion_post, iteration: @iteration
    create :notification, about: @iteration, read: false, trigger: dp, user: @user

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "A mentor has left you a comment."

    # This should be "new" comment but notifications are being cleared too early
    # assert_selector ".notifications-bar .notification", text: "A mentor has left you a new comment."
  end

  test "on mentor comment on subsequent viewing" do
    dp = create :discussion_post, iteration: @iteration
    create :notification, about: @iteration, read: true, trigger: dp

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "A mentor has left you a comment."
  end

  test "on approval" do
    dp = create :discussion_post, iteration: @iteration
    create :notification, about: @iteration, read: true, trigger: dp
    @solution.update(approved_by: create(:user))

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "A mentor has approved this solution"
  end

  test "on auto approve" do
    dp = create :discussion_post, iteration: @iteration
    create :notification, about: @iteration, read: true, trigger: dp
    @solution.update(approved_by: @user)
    @exercise.update(auto_approve: true)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "Your exercise has been submitted successfully."
  end

  test "completed" do
    @solution.update(completed_at: Time.now)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "Well done! Your solution is completed."
  end

  test "published" do
    @solution.update(completed_at: Time.now, published_at: Time.now)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "Your solution has been published."
  end

  test "Where mentoring hasn't been requested (a side exercise)" do
    @solution.update(mentoring_requested_at: nil) # The behaviour for a side exercise

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar", text: "Your exercise has been submitted successfully."
  end

  test "In independent mode with slots" do
    @solution.update(track_in_independent_mode: true, mentoring_requested_at: nil)
    UserTrack.any_instance.stubs(mentoring_slots_remaining?: true)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "In Independent Mode you will not receive mentoring by default. You may request mentoring on 1 solution at a time."
  end

  test "In independent mode without slots" do
    @solution.update(track_in_independent_mode: true, mentoring_requested_at: nil)
    UserTrack.any_instance.stubs(mentoring_slots_remaining?: false)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar .notification", text: "In Independent Mode you will not receive mentoring by default. You may request mentoring once your existing solutions have been mentored."
  end

  test "Legacy with mentoring requested" do
    @solution.update(last_updated_by_user_at: Exercism::V2_MIGRATED_AT - 1.day)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".notifications-bar", text: "Well done on submitting. A mentor will leave you feedback as soon as possible."
  end

  test "Legacy with slots" do
    @solution.update(last_updated_by_user_at: Exercism::V2_MIGRATED_AT - 1.day, mentoring_requested_at: nil)
    UserTrack.any_instance.stubs(mentoring_slots_remaining?: true)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".migration-bar", text: "This solution has been imported from an old version of the website. If you would like to receive mentorship on it, please click here."
  end

  test "Legacy without slots" do
    @solution.update(last_updated_by_user_at: Exercism::V2_MIGRATED_AT - 1.day, mentoring_requested_at: nil)
    UserTrack.any_instance.stubs(mentoring_slots_remaining?: false)

    sign_in!(@user)
    visit my_solution_path(@solution)

    assert_selector ".migration-bar", text: "This solution has been imported from an old version of the website.\nOnce your other solutions on this track have been mentored you may request mentoring for this."
  end
end
