require 'test_helper'

class Git::FetchRepoTest < ActiveSupport::TestCase
  test "fetches repo" do
    repo = mock()
    repo.stubs(:repo_url)
    repo.stubs(:head)

    repo.expects(:fetch!)

    Git::FetchRepo.(repo)
  end
end
