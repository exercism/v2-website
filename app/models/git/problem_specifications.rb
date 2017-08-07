class Git::ProblemSpecifications < Git::RepoBase

  REPO_URL="https://github.com/exercism/problem-specifications"

  def self.head
    new(REPO_URL)
  end

  class Exercise
    attr_reader :repo, :exercise_tree

    def initialize(repo, exercise_tree)
      @repo = repo
      @exercise_tree = exercise_tree
    end

    def metadata
      ptr = exercise_tree["metadata.yml"]
      blob = repo.lookup(ptr[:oid])
      YAML.load(blob.text).symbolize_keys
    rescue => e
      puts e.message
      puts e.backtrace
      {}
    end

    def description
      ptr = exercise_tree["description.md"]
      blob = repo.lookup(ptr[:oid])
      blob.text
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

  def initialize(repo_url, auto_fetch=false)
    super
  end

  def exercises
    Exercises.new(repo, head_commit)
  end

  def fetch!
    repo.fetch('origin')
  end

  def head
    head_commit.oid
  end
end
