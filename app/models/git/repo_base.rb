class Git::RepoBase
  cattr_accessor :repo_base_dir

  class << self
    def configure
      yield(self)
    end

    def clear!
      FileUtils.rm_rf(repo_base_dir)
    end
  end

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

  def read_blob(oid, default=nil)
    blob = lookup(oid)
    return default if blob.nil?
    blob.text
  rescue => e
    puts e.message
    default
  end

  def lookup(oid)
    repo.lookup(oid)
  end

  def read_json_blob(oid)
    raw = read_blob(oid)
    JSON.parse(raw, symbolize_names: true)
  end

  def read_yaml_blob(oid, default={})
    raw = read_blob(oid)
    YAML.load(raw).symbolize_keys
  rescue => e
    puts e.message
    default
  end

  private

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

  def head_commit
    main_branch.target
  end

  def main_branch
    repo.branches[main_branch_ref]
  end

  def main_branch_ref
    "origin/master"
  end

  def auto_fetch?
    !! @auto_fetch
  end

  def repo_dir_exists?
    File.directory?(repo_dir)
  end

  def repo_dir
    "#{self.class.repo_base_dir}/#{url_hash}-#{local_name}"
  end

  def url_hash
    Digest::SHA1.hexdigest(repo_url)
  end

  def local_name
    repo_url.split("/").last
  end
end
