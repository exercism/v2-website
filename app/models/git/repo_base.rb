class Git::RepoBase

  REPO_BASE_DIR="#{Rails.root}/tmp/git_repo_cache"

  attr_reader :repo_url

  def initialize(repo_url, auto_fetch=false)
    @repo_url = repo_url
    @auto_fetch = auto_fetch
  end

  def fetch!
    repo.fetch('origin')
  end

  def head
    head_commit.oid
  end

  private

  def head_commit
    main_branch.target
  end

  def main_branch
    repo.branches[main_branch_ref]
  end

  def main_branch_ref
    "origin/master"
  end

  def repo
    @repo ||= if repo_dir_exists?
      r = Rugged::Repository.new(repo_dir)
      r.fetch('origin') if auto_fetch?
      r
    else
      Rugged::Repository.clone_at(repo_url, repo_dir, bare: true)
    end
  rescue => e
    Rails.logger.error "Failed to clone repo #{repo_url}"
    Rails.logger.error e.message
    raise
  end

  def auto_fetch?
    !! @auto_fetch
  end

  def repo_dir_exists?
    File.directory?(repo_dir)
  end

  def repo_dir
    "#{REPO_BASE_DIR}/#{url_hash}-#{local_name}"
  end

  def url_hash
    Digest::SHA1.hexdigest(repo_url)
  end

  def local_name
    repo_url.split("/").last
  end
end
