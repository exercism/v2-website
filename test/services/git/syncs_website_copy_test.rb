require_relative '../../test_helper'

class Git::SyncsWebsiteCopyTest < ActiveJob::TestCase
  test "creates mentors" do
    Git::WebsiteContent.stubs(:repo_url).returns("file://#{Rails.root}/test/fixtures/website-copy")
    track = create(:track, slug: "go")

    Git::SyncsWebsiteCopy.()

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
    Git::WebsiteContent.stubs(:repo_url).returns("file://#{Rails.root}/test/fixtures/website-copy")
    track = create(:track, slug: "go")
    mentor = create(:mentor,
                    track: track,
                    github_username: "kytrinyx",
                    avatar_url: "avatars.com/avatar.png")

    Git::SyncsWebsiteCopy.()

    mentor.reload
    assert_nil mentor.avatar_url
  end

  test "deletes mentors" do
    Git::WebsiteContent.stubs(:repo_url).returns("file://#{Rails.root}/test/fixtures/website-copy")
    track = create(:track, slug: "go")
    create(:mentor, github_username: "other_mentor")

    Git::SyncsWebsiteCopy.()

    assert_equal 1, Mentor.count
  end
end
