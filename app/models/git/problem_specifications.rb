class Git::ProblemSpecifications < Git::RepoBase
  REPO_URL="https://github.com/exercism/problem-specifications"

  def self.repo_url
    REPO_URL
  end

  def self.head
    new(repo_url)
  end

  def initialize(repo_url, auto_fetch=false)
    super
  end

  def ==(other)
    repo_url == other.repo_url
  end

  def exercises
    Exercises.new(self, head_commit)
  end

  class Exercise
    attr_reader :repo, :exercise_tree

    def initialize(repo, exercise_tree)
      @repo = repo
      @exercise_tree = exercise_tree
    end

    def metadata
      ptr = exercise_tree["metadata.yml"]
      repo.read_yaml_blob(ptr[:oid], {})
    end

    def description
      ptr = exercise_tree["description.md"]
      repo.read_blob(ptr[:oid], "")
    rescue => e
      puts e.message
      puts e.backtrace
      ""
    end

    def blurb
      m = metadata
      return nil if m.nil?
      metadata[:blurb]
    end

    def title
      metadata[:title]
    end
  end

  class Exercises
    attr_reader :repo, :head_commit

    def initialize(repo, head_commit)
      @repo = repo
      @head_commit = head_commit
    end

    def [](slug)
      tree = exercise_tree(slug)
      return nil if tree.nil?
      Exercise.new(repo, tree)
    end

    def exercise_tree(slug)
      ptr = exercises_tree[slug]
      return nil if ptr.nil?
      repo.lookup(ptr[:oid])
    end

    def exercises_tree
      exercises_ptr = head_commit.tree['exercises']
      repo.lookup(exercises_ptr[:oid])
    end
  end
end
