require_relative '../../test_helper'

class Git::SyncBlogPostsTest < ActiveSupport::TestCase
  test "creates blog_posts" do
    repo = mock()
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
          "marketing_copy": "Learn about our plans for Exercism in 2019"
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
  end

  test "updates blog_posts" do
    skip
    Git::GithubProfile.stubs(:for_user)
    track = create(:track, slug: "go")
    blog_post = create(:blog_post,
                    track: track,
                    github_username: "kytrinyx",
                    avatar_url: "avatars.com/avatar.png",
                    link_text: nil,
                    link_url: nil)
    repo = mock()
    repo.
      stubs(:blog_posts).
      returns([
        {
          github_username: "kytrinyx",
          name: "Katrina Owen",
          link_text: "Link",
          link_url: "example.com",
          avatar_url: "avatar.png",
          bio: "Bio",
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncBlogPosts.(repo)
    end

    blog_post.reload
    assert "avatar.png", blog_post.avatar_url
    assert "example.com", blog_post.link_text
    assert "Link", blog_post.link_url
  end

  test "deletes blog_posts" do
    skip
    Git::GithubProfile.stubs(:for_user)
    track = create(:track, slug: "go")
    create(:blog_post, github_username: "other_blog_post")
    repo = mock()
    repo.
      stubs(:blog_posts).
      returns([
        {
          github_username: "kytrinyx",
          name: "Katrina Owen",
          link_text: "Link",
          link_url: "example.com",
          avatar_url: "avatar.png",
          bio: "Bio",
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncBlogPosts.(repo)
    end

    assert_equal 1, BlogPost.count
  end

  test "retrieves Github Profile data for empty fields" do
    skip
    track = create(:track, slug: "go")
    Git::GithubProfile.stubs(
      for_user: stub(
        name: "Name",
        avatar_url: "avatar.png",
        bio: "Bio",
        link_url: "example.com"
      )
    )
    repo = mock()
    repo.
      stubs(:blog_posts).
      returns([
        {
          github_username: "kytrinyx",
          name: nil,
          link_text: nil,
          link_url: nil,
          avatar_url: nil,
          bio: nil,
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncBlogPosts.(repo)
    end

    blog_post = BlogPost.last
    assert_equal "Name", blog_post.name
    assert_equal "avatar.png", blog_post.avatar_url
    assert_equal "Bio", blog_post.bio
    assert_equal "example.com", blog_post.link_url
    assert_equal "example.com", blog_post.link_text
  end

  test "skips Github Profile data when unable to retrieve them" do
    skip
    track = create(:track, slug: "go")
    Git::GithubProfile.
      stubs(:for_user).
      raises(Git::GithubProfile::NotFoundError)
    repo = mock()
    repo.
      stubs(:blog_posts).
      returns([
        {
          github_username: "kytrinyx",
          name: "Name",
          link_text: nil,
          link_url: nil,
          avatar_url: nil,
          bio: nil,
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncBlogPosts.(repo)
    end

    blog_post = BlogPost.last
    assert_equal "Name", blog_post.name
    assert_nil blog_post.link_text
    assert_nil blog_post.link_url
    assert_nil blog_post.avatar_url
    assert_nil blog_post.bio
  end
end

