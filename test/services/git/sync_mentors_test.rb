require_relative '../../test_helper'

class Git::SyncMentorsTest < ActiveSupport::TestCase
  test "creates mentors" do
    Git::GithubProfile.stubs(:for_user)
    track = create(:track, slug: "go")
    repo = mock()
    repo.
      stubs(:mentors).
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
      Git::SyncMentors.(repo)
    end

    mentor = Mentor.last
    assert_equal track, mentor.track
    assert_equal "Katrina Owen", mentor.name
    assert "avatar.png", mentor.avatar_url
    assert_equal "kytrinyx", mentor.github_username
    assert "example.com", mentor.link_text
    assert "Link", mentor.link_url
    assert_equal "Bio", mentor.bio
  end

  test "updates mentors" do
    Git::GithubProfile.stubs(:for_user)
    track = create(:track, slug: "go")
    mentor = create(:mentor,
                    track: track,
                    github_username: "kytrinyx",
                    avatar_url: "avatars.com/avatar.png",
                    link_text: nil,
                    link_url: nil)
    repo = mock()
    repo.
      stubs(:mentors).
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
      Git::SyncMentors.(repo)
    end

    mentor.reload
    assert "avatar.png", mentor.avatar_url
    assert "example.com", mentor.link_text
    assert "Link", mentor.link_url
  end

  test "deletes mentors" do
    Git::GithubProfile.stubs(:for_user)
    track = create(:track, slug: "go")
    create(:mentor, github_username: "other_mentor")
    repo = mock()
    repo.
      stubs(:mentors).
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
      Git::SyncMentors.(repo)
    end

    assert_equal 1, Mentor.count
  end

  test "retrieves Github Profile data for empty fields" do
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
      stubs(:mentors).
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
      Git::SyncMentors.(repo)
    end

    mentor = Mentor.last
    assert_equal "Name", mentor.name
    assert_equal "avatar.png", mentor.avatar_url
    assert_equal "Bio", mentor.bio
    assert_equal "example.com", mentor.link_url
    assert_equal "example.com", mentor.link_text
  end

  test "skips Github Profile data when unable to retrieve them" do
    track = create(:track, slug: "go")
    Git::GithubProfile.
      stubs(:for_user).
      raises(Git::GithubProfile::NotFoundError)
    repo = mock()
    repo.
      stubs(:mentors).
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
      Git::SyncMentors.(repo)
    end

    mentor = Mentor.last
    assert_equal "Name", mentor.name
    assert_nil mentor.link_text
    assert_nil mentor.link_url
    assert_nil mentor.avatar_url
    assert_nil mentor.bio
  end
end
