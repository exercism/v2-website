class Git::ExercismRepo < Git::RepoBase

  def self.current_head(repo_url)
    new(repo_url).head
  end

  def initialize(repo_url, auto_fetch=false)
    super
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

  def exercise(exercise_slug, commit_sha=head)
    commit = repo.lookup(commit_sha)
    if commit.type != :commit
      raise 'not-found'
    end
    config = read_config(commit)
    Git::ExerciseReader.new(repo, repo_url, exercise_slug, commit, config)
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
end
