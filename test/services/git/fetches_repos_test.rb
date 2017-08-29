require 'test_helper'

class Git::FetchesReposTest < ActiveSupport::TestCase
  test "fetches repos" do
    repo = mock()
    repo.stubs(:repo_url)
    repo.stubs(:head)

    repo.expects(:fetch!)

    Git::FetchesRepos.fetch([repo])
  end
end
