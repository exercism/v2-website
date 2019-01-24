require 'test_helper'

class CreateBlogCommentTest < ActiveSupport::TestCase
  test "creates correctly" do
    blog_post = create :blog_post
    user = create :user
    content = "foobar"
    html = "<p>foobar</p>"

    comment = CreateBlogComment.(blog_post, user, content)

    assert comment.persisted?
    assert_equal blog_post, comment.blog_post
    assert_equal user, comment.user
    assert_equal content, comment.content
    assert_equal html, comment.html.strip
  end

  test "notifications work correctly" do
    blog_post_author = create :user
    other_user_1 = create :user
    other_user_2 = create :user
    blog_post = create :blog_post, author: blog_post_author

    comment_1 = CreateBlogComment.(blog_post, other_user_1, "foobar")
    assert_equal 1, Notification.count
    assert_notification(blog_post, blog_post_author, :new_blog_comment_for_blog_post_author, comment_1)

    blog_post.reload
    comment_2 = CreateBlogComment.(blog_post, blog_post_author, "foobar2")
    assert_equal 2, Notification.count
    assert_notification(blog_post, other_user_1, :new_blog_comment_for_other_commenter, comment_2)

    blog_post.reload
    comment_3 = CreateBlogComment.(blog_post, other_user_2, "foobar3")
    assert_equal 4, Notification.count
    assert_notification(blog_post, blog_post_author, :new_blog_comment_for_blog_post_author, comment_3)
    assert_notification(blog_post, other_user_1, :new_blog_comment_for_other_commenter, comment_3)

    blog_post.reload
    comment_4 = CreateBlogComment.(blog_post, other_user_1, "foobar4")
    assert_equal 6, Notification.count
    assert_notification(blog_post, blog_post_author, :new_blog_comment_for_blog_post_author, comment_4)
    assert_notification(blog_post, other_user_2, :new_blog_comment_for_other_commenter, comment_4)
  end

  def assert_notification(blog_post, user, type, comment)
    assert Notification.where(
      about: blog_post,
      user: user,
      type: type,
      link: Rails.application.routes.url_helpers.blog_post_url(blog_post, anchor: "comment-#{comment}"),
      trigger: comment
    ).exists?
  end

end
