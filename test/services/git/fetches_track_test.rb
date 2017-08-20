require 'test_helper'

class Git::FetchesTrackTest < ActiveSupport::TestCase
  test "fetches problem specifications" do
    track = build_stubbed(:track)
    Git::WebsiteContent.stubs(:head).returns(stub(:fetch!))

    repo = mock()
    Git::ProblemSpecifications.expects(:head).returns(repo)
    repo.expects(:fetch!)

    Git::FetchesTrack.fetch(track)
  end

  test "fetches website content" do
    track = build_stubbed(:track)
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))

    repo = mock()
    Git::WebsiteContent.expects(:head).returns(repo)
    repo.expects(:fetch!)

    Git::FetchesTrack.fetch(track)
  end

  test "fetches track when not from http://example.com" do
    track = build_stubbed(:track, repo_url: "http://github.com/exercism/csharp")
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    Git::WebsiteContent.stubs(:head).returns(stub(:fetch!))

    Git::ExercismRepo.expects(:new).with(track.repo_url, auto_fetch: true)

    Git::FetchesTrack.fetch(track)
  end

  test "doesn't fetch track when from http://example.com" do
    track = build_stubbed(:track, repo_url: "http://example.com/repos/csharp")
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    Git::WebsiteContent.stubs(:head).returns(stub(:fetch!))

    Git::ExercismRepo.expects(:new).never

    Git::FetchesTrack.fetch(track)
  end
end
