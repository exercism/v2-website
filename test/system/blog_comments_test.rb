require "application_system_test_case"

class BlogCommentsTest < ApplicationSystemTestCase

  test "user posts a blog comment" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    blog_post = create(:blog_post)

    sign_in!(user)
    visit blog_post_path(blog_post)

    text = "Some sample content"
    find(".new-editable-text textarea").set(text)
    click_on "Comment"

    assert_text text
    comment = BlogComment.last
    assert_equal text, comment.content
    assert_equal user, comment.user
    assert_equal blog_post, comment.blog_post
  end

  test "user edits a blog comment" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    blog_post = create(:blog_post)
    blog_comment = create(:blog_comment,
                             content: "Hello!",
                             html: "<p>Hello!</p>",
                             user: user,
                             blog_post: blog_post)
    sign_in!(user)
    visit blog_post_path(blog_post)
    click_on "Edit"
    within(".blog-comment.editing") { fill_in("blog_comment_content", with: "Hey!") }
    click_on "Save changes"

    assert_text "Hey!"
    # I've commented this line out in the HAML for now
    # assert_text "(edited less than a minute ago)"
    blog_comment.reload
    assert_equal "Hello!", blog_comment.previous_content
  end

  test "user deletes a blog comment" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    blog_post = create(:blog_post)
    blog_comment = create(:blog_comment,
                             content: "Hello!",
                             html: "<p>Hello!</p>",
                             user: user,
                             blog_post: blog_post)

    sign_in!(user)
    visit blog_post_path(blog_post)
    accept_confirm do
      click_on "Delete"
    end

    assert_text "This message has been deleted"
  end

  test "comment button clears preview tab" do
    blog_post = create(:blog_post)

    sign_in!
    visit blog_post_path(blog_post)

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
    blog_post = create(:blog_post)

    sign_in!
    visit blog_post_path(blog_post)

    assert_selector ".comment-button"
    assert_selector ".markdown"
    refute_selector ".preview"

    assert_equal "", find(".new-editable-text textarea").value
    find(".new-editable-text textarea").set("An example mentor comment to test the comment button!")

    visit blog_post_path(blog_post)

    assert_equal "An example mentor comment to test the comment button!", find(".new-editable-text textarea").value
    find(".new-editable-text textarea").set("")

    visit blog_post_path(blog_post)

    assert_equal "", find(".new-editable-text textarea").value
  end
end
