require 'test_helper'

class BlogPostTest < ActiveSupport::TestCase
  test "author is found if exists and case insensitive" do
    user = create :user, handle: 'ihid'
    assert_equal user, create(:blog_post, author_handle: 'ihid').author
    assert_equal user, create(:blog_post, author_handle: 'iHiD').author
    assert_nil create(:blog_post, author_handle: 'foobar').author
  end

  test "published and scheduled scopes works" do
    published = create :blog_post, published_at: Time.current - 1.minute
    scheduled = create :blog_post, published_at: Time.current + 1.minute

    assert_equal [published], BlogPost.published
    assert_equal [scheduled], BlogPost.scheduled
  end

  test "to_param" do
    slug = "foobar"
    blog_post = create :blog_post, slug: slug
    assert_equal slug, blog_post.to_param
  end

  test "BlogPost.categories" do
    categories = ["first", "second"]

    create :blog_post, category: categories[0], published_at: Time.current - 1.minute
    create :blog_post, category: categories[1], published_at: Time.current - 1.minute

    # Duplicate
    create :blog_post, category: categories[0], published_at: Time.current - 1.minute

    # Not published
    create :blog_post, category: "unpublished", published_at: Time.current + 1.minute

    assert_equal categories, BlogPost.categories
  end

  test "BlogPost.categories_woth_counts" do
    categories = ["first", "second"]

    create :blog_post, category: categories[0], published_at: Time.current - 1.minute
    create :blog_post, category: categories[0], published_at: Time.current - 1.minute
    create :blog_post, category: categories[1], published_at: Time.current - 1.minute

    # Not published
    create :blog_post, category: "unpublished", published_at: Time.current + 1.minute

    assert_equal [
      ["first", 2],
      ["second", 1]
    ], BlogPost.categories_with_counts
  end

end
