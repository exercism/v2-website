require 'test_helper'

class BlogCommentsControllerTest < ActionDispatch::IntegrationTest
  test "prevents forbidden users from commenting" do
    user = create(:user, :onboarded)
    blog_post = create(:blog_post, :published)
    AllowedToCommentPolicy.stubs(:allowed?).returns(false)

    sign_in!(user)
    post blog_comments_path(blog_post_id: blog_post.id),
      params: {
        blog_comment: {
          content: "Forbidden comment"
        }
      }

    assert_response :unprocessable_entity
  end
end
