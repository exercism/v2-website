require 'test_helper'

class Git::FetchReposTest < ActiveSupport::TestCase
  test "fetches repos" do
    repo = mock()

    Git::FetchRepo.expects(:call).with(repo)
    Git::FetchRepos.([repo])
  end
end
