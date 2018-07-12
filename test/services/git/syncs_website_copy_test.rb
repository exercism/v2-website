require_relative '../../test_helper'

class Git::SyncsWebsiteCopyTest < ActiveJob::TestCase
  test "syncs mentors" do
    Git::WebsiteContent.stubs(:repo_url).returns("file://#{Rails.root}/test/fixtures/website-copy")
    track = create(:track, slug: "go")

    stub_repo_cache! do
      Git::SyncsWebsiteCopy.()
    end

    mentor = Mentor.last
    assert_equal track, mentor.track
    assert_equal "Katrina Owen", mentor.name
    assert_nil mentor.avatar_url
    assert_equal "kytrinyx", mentor.github_username
  end
end
