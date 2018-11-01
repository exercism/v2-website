require "test_helper"

class Git::WebsiteContentTest < ActiveSupport::TestCase
  test "equal when repo urls are the same" do
    repo = Git::WebsiteContent.new("https://github.com/exercism/website-copy")
    another_repo = Git::WebsiteContent.new("https://github.com/exercism/website-copy")

    assert_equal repo, another_repo
  end

  test "unequal when repo urls are different" do
    repo = Git::WebsiteContent.new("https://github.com/exercism/website-copy")
    another_repo = Git::WebsiteContent.new("https://github.com/exercism/website-copy-v2")

    refute_equal repo, another_repo
  end

  test "returns mentoring notes" do
    skip
    track = create :track, slug: "ruby"
    exercise = create :exercise, slug: "grains", track: track

    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")

    stub_repo_cache! do
      repo = Git::WebsiteContent.new("file://#{Rails.root}/test/fixtures/website-copy")

      assert_equal(
        "Welcome to the Exercism installation guide!\n",
        repo.mentor_notes_for
      )
    end
  end

  test "returns mentor data" do
    stub_repo_cache! do
      repo = Git::WebsiteContent.new("file://#{Rails.root}/test/fixtures/website-copy")

      expected = [
        {
          github_username: "kytrinyx",
          name: "Katrina Owen",
          link_text: "Link",
          link_url: "example.com",
          avatar_url: "avatar.png",
          bio: "Bio",
          track: "go"
        }
      ]

      assert_equal expected, repo.mentors
    end
  end

  test "returns walkthrough content" do
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")

    stub_repo_cache! do
      repo = Git::WebsiteContent.new("file://#{Rails.root}/test/fixtures/website-copy")

      assert_equal(
        "Welcome to the Exercism installation guide!\n",
        repo.walkthrough
      )
    end
  end
end
