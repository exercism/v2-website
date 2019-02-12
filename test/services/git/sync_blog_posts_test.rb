require_relative '../../test_helper'

class Git::SyncBlogPostsTest < ActiveSupport::TestCase
  test "creates blog_posts" do
    repo = mock
    repo.
      stubs(:blog_posts).
      returns([
        {
          "uuid": "e1853292-1fab-4a48-babc-4234ac196ac1",
          "slug": "exercism-in-2019",
          "category": "updates",
          "published_at": "2019-01-10 19:12",
          "content_repository": "blog",
          "content_filepath": "posts/exercism-in-2019.md",
          "title": "Exercism in 2019",
          "author_handle": "iHiD",
          "marketing_copy": "Learn about our plans for Exercism in 2019",
          "image_url": "http://foo.bar"
        }
      ])

    stub_repo_cache! do
      Git::SyncBlogPosts.(repo)
    end

    blog_post = BlogPost.last
    assert_equal "e1853292-1fab-4a48-babc-4234ac196ac1", blog_post.uuid
    assert_equal "exercism-in-2019", blog_post.slug
    assert_equal "updates", blog_post.category
    assert_equal Time.new(2019,01,10,19,12), blog_post.published_at
    assert_equal "blog", blog_post.content_repository
    assert_equal "posts/exercism-in-2019.md", blog_post.content_filepath
    assert_equal "Exercism in 2019", blog_post.title
    assert_equal "iHiD", blog_post.author_handle
    assert_equal "Learn about our plans for Exercism in 2019", blog_post.marketing_copy
    assert_equal "http://foo.bar", blog_post.image_url
  end

  test "updates blog_posts" do
    uuid = "e1853292-1fab-4a48-babc-4234ac196ac2"
    blog_post = create :blog_post, uuid: uuid
    repo = mock
    repo.
      stubs(:blog_posts).
      returns([
        {
          "uuid": uuid,
          "slug": "exercism-in-2019",
          "category": "updates",
          "published_at": "2019-01-10 19:12",
          "content_repository": "blog",
          "content_filepath": "posts/exercism-in-2019.md",
          "title": "Exercism in 2019",
          "author_handle": "iHiD",
          "marketing_copy": "Learn about our plans for Exercism in 2019",
          "image_url": "http://foo.bar"
        }
      ])

    stub_repo_cache! do
      Git::SyncBlogPosts.(repo)
    end

    blog_post.reload
    assert_equal uuid, blog_post.uuid
    assert_equal "exercism-in-2019", blog_post.slug
    assert_equal "updates", blog_post.category
    assert_equal Time.new(2019,01,10,19,12), blog_post.published_at
    assert_equal "blog", blog_post.content_repository
    assert_equal "posts/exercism-in-2019.md", blog_post.content_filepath
    assert_equal "Exercism in 2019", blog_post.title
    assert_equal "iHiD", blog_post.author_handle
    assert_equal "Learn about our plans for Exercism in 2019", blog_post.marketing_copy
    assert_equal "http://foo.bar", blog_post.image_url
  end
end
