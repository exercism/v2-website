require "application_system_test_case"

class SolutionCommentsTest < ApplicationSystemTestCase
  setup do
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))

    @track = create :track
    @solution = create :solution, exercise: create(:exercise, track: @track),
                                  published_at: Time.current,
                                  allow_comments: true
    @iteration = create :iteration, solution: @solution
  end

  test "user posts a solution comment" do
    sign_in!(@user)
    visit solution_path(@solution)

    text = "Some sample content"
    find(".new-editable-text textarea").set(text)
    click_on "Comment"

    assert_text text
    solution_comment = SolutionComment.last
    assert_equal text, solution_comment.content
    assert_equal @user, solution_comment.user
    assert_equal @solution, solution_comment.solution
  end

  test "user edits a solution comment" do
    sign_in!(@user)
    solution_comment = create(:solution_comment,
                               solution: @solution,
                               content: "Hello!",
                               html: "<p>Hello!</p>",
                               user: @user)
    visit solution_path(@solution)
    click_on "Edit"
    within(".editable-text.editing") { fill_in("solution_comment_content", with: "Hey!") }
    click_on "Save changes"

    assert_text "Hey!"
    # I've commented this line out in the HAML for now
    # assert_text "(edited less than a minute ago)"
    solution_comment.reload
    assert_equal "Hello!", solution_comment.previous_content
  end

  test "user deletes a solution comment" do
    sign_in!(@user)
    solution_comment = create(:solution_comment,
                               solution: @solution,
                               content: "Hello!",
                               html: "<p>Hello!</p>",
                               user: @user)

    visit solution_path(@solution)
    accept_confirm do
      click_on "Delete"
    end

    assert_text "This message has been deleted"
  end

  test "comment button clears preview tab" do
    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector ".comment-button"
    assert_selector ".markdown"
    refute_selector ".preview"

    find(".new-editable-text textarea").set("An example mentor comment to test the comment button!")
    find(".preview-tab").click
    within(".preview-area") { assert_text "An example mentor comment to test the comment button!" }
    click_on "Comment"
    within(".preview-area") { assert_text "", { exact: true } }
  end

  test "localstorage saves comment draft" do
    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector ".comment-button"
    assert_selector ".markdown"
    refute_selector ".preview"

    assert_equal "", find(".new-editable-text textarea").value
    find(".new-editable-text textarea").set("An example mentor comment to test the comment button!")

    visit solution_path(@solution)

    assert_equal "An example mentor comment to test the comment button!", find(".new-editable-text textarea").value
    find(".new-editable-text textarea").set("")

    visit solution_path(@solution)

    assert_equal "", find(".new-editable-text textarea").value
  end

  test "user cannot post comment if disabled" do
    @solution.update(allow_comments: false)
    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector(".comments-disabled")
    refute_selector(".new-editable-text textarea")
  end

  test "user cannot post comment if disabled even if there are old comments" do
    @solution.update(allow_comments: false)
    create :solution_comment, solution: @solution

    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector(".comments-disabled")
    refute_selector(".new-editable-text textarea")
  end

  test "non-solution user cannot enable comments" do
    @solution.update(allow_comments: false)

    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector(".comments-disabled")
    refute_selector(".comments-disabled .pure-button")
    refute_selector(".new-editable-text textarea")
  end

  test "solution user can enable comments" do
    @solution.update(allow_comments: false, user: @user)

    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector(".comments-disabled .pure-button")
    refute_selector(".new-editable-text textarea")
    click_on "Enable comments"

    assert_selector(".new-editable-text textarea")
  end

  test "non-solution user cannot disable comments" do
    sign_in!(@user)
    visit solution_path(@solution)

    refute_selector(".disable-comments")
  end

  test "solution user can disable comments" do
    @solution.update(user: @user)

    sign_in!(@user)
    visit solution_path(@solution)

    assert_selector(".disable-comments")
    assert_selector(".new-editable-text textarea")
    click_on "Disable comments"

    refute_selector(".new-editable-text textarea")
  end
end
