require 'test_helper'

class Git::FetchesTracksTest < ActiveSupport::TestCase
  test "fetches problem specifications" do
    Git::WebsiteContent.stubs(:head).returns(stub(:fetch!))

    repo = mock()
    Git::ProblemSpecifications.expects(:head).returns(repo)
    repo.expects(:fetch!)

    Git::FetchesTracks.fetch([])
  end

  test "fetches website content" do
    track = build_stubbed(:track)
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))

    repo = mock()
    Git::WebsiteContent.expects(:head).returns(repo)
    repo.expects(:fetch!)

    Git::FetchesTracks.fetch([])
  end

  test "fetches track when not from http://example.com" do
    track = build_stubbed(:track, repo_url: "http://github.com/exercism/csharp")
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    Git::WebsiteContent.stubs(:head).returns(stub(:fetch!))

    repo = mock()
    Git::ExercismRepo.expects(:new).with(track.repo_url).returns(repo)
    repo.expects(:fetch!)
    repo.stubs(:head)

    Git::FetchesTracks.fetch([track])
  end

  test "does not fetch track when from http://example.com" do
    track = build_stubbed(:track, repo_url: "http://example.com/repos/csharp")
    Git::ProblemSpecifications.stubs(:head).returns(stub(:fetch!))
    Git::WebsiteContent.stubs(:head).returns(stub(:fetch!))

    Git::ExercismRepo.expects(:new).with(track.repo_url).never

    Git::FetchesTracks.fetch([track])
  end
end
