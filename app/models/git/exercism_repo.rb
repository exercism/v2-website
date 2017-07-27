class Git::ExercismRepo

  def self.current_head(repo_url)
    new(repo_url).head
  end

  REPO_BASE="#{Rails.root}/tmp/git_repo_cache"

  attr_reader :repo_url

  def initialize(repo_url, auto_fetch=false)
    @repo_url = repo_url
    @auto_fetch = auto_fetch
  end

  def snippet_file
    read_snippet(head_commit)
  end

  def about
    read_about(head_commit)
  end

  def config
    read_config(head_commit)
  end

  def maintainer_config
    read_maintainer_config(head_commit)
  end

  def exercise(exercise_slug, commit_sha)
    commit = repo.lookup(commit_sha)
    if commit.type != :commit
      raise 'not-found'
    end
    config = read_config(commit)
    Git::ExerciseReader.new(repo, exercise_slug, commit, config)
  rescue Rugged::OdbError => e
    raise 'not-found'
  end

  def fetch!
    repo.fetch('origin')
  end

  def head
    head_commit.oid
  end

  private

  def read_about(commit)
    read_docs(commit, "ABOUT.md")
  end

  def read_snippet(commit)
    read_docs(commit, "SNIPPET.txt")
  end

  def read_docs(commit, file_name)
    docs_tree_ptr = commit.tree['docs']
    return nil if docs_tree_ptr.nil?
    docs_tree = repo.lookup(docs_tree_ptr[:oid])
    file_pointer = docs_tree[file_name]
    return nil if file_pointer.nil?
    blob = repo.lookup(file_pointer[:oid])
    blob.text
  end

  def read_config(commit)
    config_pointer = commit.tree['config.json']
    config_blob = repo.lookup(config_pointer[:oid])
    JSON.parse(config_blob.text, symbolize_names: true)
  end

  def read_maintainer_config(commit)
    config_tree_ptr = commit.tree['config']
    return {} if config_tree_ptr.nil?
    config_tree = repo.lookup(config_tree_ptr[:oid])
    file_pointer = config_tree["maintainers.json"]
    return {} if file_pointer.nil?
    blob = repo.lookup(file_pointer[:oid])
    JSON.parse(blob.text, symbolize_names: true)
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

  def repo
    @repo ||= if repo_dir_exists?
      r = Rugged::Repository.new(repo_dir)
      r.fetch('origin') if auto_fetch?
      r
    else
      Rugged::Repository.clone_at(repo_url, repo_dir, bare: true)
    end
  end

  def auto_fetch?
    !! @auto_fetch
  end

  def repo_dir_exists?
    File.directory?(repo_dir)
  end

  def repo_dir
    "#{REPO_BASE}/#{url_hash}-#{local_name}"
  end

  def url_hash
    Digest::SHA1.hexdigest(repo_url)
  end

  def local_name
    repo_url.split("/").last
  end
end
