class Git::ExerciseReader

  attr_reader :repo, :exercise_slug, :commit, :config
  def initialize(repo, exercise_slug, commit, config)
    @repo = repo
    @exercise_slug = exercise_slug
    @commit = commit
    @config = config
  end

  def readme
    readme_ptr = exercise_tree['README.md']
    blob = repo.lookup(readme_ptr[:oid])
    blob.text
  end

  def tests
    files = exercise_files.select { |f| f[:name].match(test_pattern) }
    test_suites = {}
    files.each do |file|
      name = file[:name]
      blob = repo.lookup(file[:oid])
      test_suites[name] = blob.text
    end
    test_suites
  end

  private

  def test_pattern
    pattern = config[:test_pattern]
    return /test/i if pattern.nil?
    Regexp.new(pattern)
  end

  def exercise_files
    @exercise_files ||= begin
      exercise_files = []
      exercise_tree.walk(:preorder) do |r, t|
        path = "#{r}#{t[:name]}"
        t[:full] = path
        exercise_files.push(t) unless path.start_with?(".meta")
      end
      exercise_files
    end
  end

  def tree
    commit.tree
  end

  def exercise_tree
    oid = tree['exercises'][:oid]
    t = repo.lookup(oid)
    entry = t[exercise_slug]
    oid = entry[:oid]
    repo.lookup(oid)
  end

end
