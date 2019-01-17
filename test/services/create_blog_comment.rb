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
end
