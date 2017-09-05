require 'test_helper'

class RepoUpdateFetchTest < ActiveSupport::TestCase
  test "validates presence of repo update" do
    repo_update_fetch = build(:repo_update_fetch, repo_update: nil)
    refute repo_update_fetch.valid?

    repo_update_fetch = build(:repo_update_fetch, repo_update: build(:repo_update))
    assert repo_update_fetch.valid?
  end

  test "validates presence of host" do
    repo_update_fetch = build(:repo_update_fetch, host: nil)
    refute repo_update_fetch.valid?

    repo_update_fetch = build(:repo_update_fetch, host: "host-1")
    assert repo_update_fetch.valid?
  end
end
