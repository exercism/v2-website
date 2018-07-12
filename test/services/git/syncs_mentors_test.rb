require_relative '../../test_helper'

class Git::SyncsMentorsTest < ActiveSupport::TestCase
  test "creates mentors" do
    track = create(:track, slug: "go")
    repo = mock()
    repo.
      stubs(:mentors).
      returns([
        {
          github_username: "kytrinyx",
          name: "Katrina Owen",
          link_text: nil,
          link_url: nil,
          avatar_url: nil,
          bio: "Bio",
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncsMentors.(repo)
    end

    mentor = Mentor.last
    assert_equal track, mentor.track
    assert_equal "Katrina Owen", mentor.name
    assert_nil mentor.avatar_url
    assert_equal "kytrinyx", mentor.github_username
    assert_nil mentor.link_text
    assert_nil mentor.link_url
    assert_equal "Bio", mentor.bio
  end

  test "updates mentors" do
    track = create(:track, slug: "go")
    mentor = create(:mentor,
                    track: track,
                    github_username: "kytrinyx",
                    avatar_url: "avatars.com/avatar.png")
    repo = mock()
    repo.
      stubs(:mentors).
      returns([
        {
          github_username: "kytrinyx",
          name: "Katrina Owen",
          link_text: nil,
          link_url: nil,
          avatar_url: nil,
          bio: "Bio",
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncsMentors.(repo)
    end

    mentor.reload
    assert_nil mentor.avatar_url
  end

  test "deletes mentors" do
    track = create(:track, slug: "go")
    create(:mentor, github_username: "other_mentor")
    repo = mock()
    repo.
      stubs(:mentors).
      returns([
        {
          github_username: "kytrinyx",
          name: "Katrina Owen",
          link_text: nil,
          link_url: nil,
          avatar_url: nil,
          bio: "Bio",
          track: "go"
        }
      ])

    stub_repo_cache! do
      Git::SyncsMentors.(repo)
    end

    assert_equal 1, Mentor.count
  end
end
