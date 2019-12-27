require 'test_helper'

class BlogPostsControllerTest < ActionDispatch::IntegrationTest
  test "index shows published posts" do
    published = create :blog_post, published_at: Time.current - 1.minute
    scheduled = create :blog_post, published_at: Time.current + 1.minute

    get blog_posts_path
    assert_response :success
    assert_equal [published], assigns(:blog_posts)
  end

  test "show finds by slug" do
    old_slug = "foobar"
    new_slug = "barfoo"
    blog_post = create :blog_post, slug: old_slug, published_at: Time.current - 1.minute
    blog_post.update(slug: new_slug)
    get blog_post_path(old_slug)

    assert_redirected_to blog_post_path(new_slug)
  end

  test "show redirects to latest url" do
    blog_post = create :blog_post, published_at: Time.current - 1.minute
    get blog_post_path(blog_post.slug)
    assert_equal blog_post, assigns(:blog_post)
  end


  test "show 404s for unpublished post" do
    blog_post = create :blog_post, published_at: Time.current + 1.minute
    assert_raises ActiveRecord::RecordNotFound do
      get blog_post_path(blog_post.slug)
    end
  end

  test "show should clear notifications" do
    blog_post = create :blog_post, published_at: DateTime.now - 1.week
    user = create :user, :onboarded

    create :notification, about: blog_post, user: user
    create :notification, about: blog_post # A different user
    create :notification, about: create(:blog_post), user: user # A random notification
    assert_equal 3, Notification.unread.count
    assert_equal 0, Notification.read.where(about: blog_post, user: user).count

    sign_in!(user)
    get blog_post_url(blog_post)
    assert_equal 2, Notification.unread.count
    assert_equal 1, Notification.read.where(about: blog_post, user: user).count
  end
end
