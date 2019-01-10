require 'test_helper'

class BlogPostsControllerTest < ActionDispatch::IntegrationTest
  test "index shows published posts" do
    published = create :blog_post, published_at: DateTime.now - 1.minute
    scheduled = create :blog_post, published_at: DateTime.now + 1.minute

    get blog_posts_path
    assert_equal [published], assigns(:blog_posts)
  end

  test "show finds by slug" do
    # TODO - Is there a nicer way of doing this?
    BlogPost.any_instance.stubs(content: "Foobar")

    blog_post = create :blog_post, published_at: DateTime.now - 1.minute
    get blog_post_path(id: blog_post.slug)
    assert_equal blog_post, assigns(:blog_post)
  end

  test "show 404s for unpublished post" do
    blog_post = create :blog_post, published_at: DateTime.now + 1.minute
    assert_raises ActiveRecord::RecordNotFound do
      get blog_post_path(id: blog_post.slug)
    end
  end
end
