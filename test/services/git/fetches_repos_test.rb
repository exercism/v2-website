require 'test_helper'

class Git::FetchesReposTest < ActiveSupport::TestCase
  test "fetches repos" do
    repo = mock()

    Git::FetchesRepo.expects(:fetch).with(repo)

    Git::FetchesRepos.fetch([repo])
  end
end
