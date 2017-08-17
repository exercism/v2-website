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
    commit = lookup(commit_sha)
    if commit.type != :commit
      raise 'not-found'
    end
    config = read_config(commit)
    Git::ExerciseReader.new(self, exercise_slug, commit, config)
  rescue Rugged::OdbError => e
    raise 'not-found'
  end

  def test_pattern
    pattern = config[:test_pattern]
    pattern.present?? pattern : "[tT]est"
  end

  def test_regexp
    Regexp.new(test_pattern)
  end

  def ignore_regexp
    pattern = config[:ignore_pattern]
    pattern.present?? Regexp.new(pattern) : /[eE]xample/
  end

  def solution_regexp
    pattern = config[:solution_pattern]
    pattern.present?? Regexp.new(pattern) : /[eE]xample/
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
    docs_tree = lookup(docs_tree_ptr[:oid])
    file_pointer = docs_tree[file_name]
    return nil if file_pointer.nil?
    blob = lookup(file_pointer[:oid])
    blob.text
  end

  def read_config(commit)
    config_pointer = commit.tree['config.json']
    config_blob = lookup(config_pointer[:oid])
    read_json_blob(config_pointer[:oid])
  end

  def read_maintainer_config(commit)
    config_tree_ptr = commit.tree['config']
    return {} if config_tree_ptr.nil?
    config_tree = lookup(config_tree_ptr[:oid])
    file_pointer = config_tree["maintainers.json"]
    return {} if file_pointer.nil?
    read_json_blob(file_pointer[:oid])
  end
end
