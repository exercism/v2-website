require 'test_helper'

class Git::FetchesRepoTest < ActiveSupport::TestCase
  test "fetches repo" do
    repo = mock()
    repo.stubs(:repo_url)
    repo.stubs(:head)

    repo.expects(:fetch!)

    Git::FetchesRepo.fetch(repo)
  end
end
