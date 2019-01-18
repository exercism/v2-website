require "application_system_test_case"

class BlogCommentsTest < ApplicationSystemTestCase
  test "user edits a blog comment" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, track: track, user: user, independent_mode: false)
    exercise = create(:exercise, track: track)
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
    assert_text "(edited less than a minute ago)"
    blog_comment.reload
    assert_equal "Hello!", blog_comment.previous_content
  end

  test "user deletes a blog comment" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, track: track, user: user, independent_mode: false)
    exercise = create(:exercise, track: track)
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
end
