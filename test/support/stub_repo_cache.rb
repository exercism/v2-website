module StubRepoCache
  def stub_repo_cache!(&block)
    git_repo_cache = "#{Rails.root}/test/tmp/git_repo_cache"
    Git::RepoBase.
      stubs(:repo_base_dir).
      returns(git_repo_cache)

    begin
      yield
    ensure
      FileUtils.rm_rf(git_repo_cache)
    end
  end
end
