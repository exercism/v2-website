class GitExercise
  attr_reader :track, :exercise, :git_slug, :git_sha
  def initialize(exercise, git_slug, git_sha)
    @track = exercise.track
    @exercise = exercise
    @git_slug = git_slug
    @git_sha = git_sha
  end

  # TODOGIT
  def instructions
  end

  # TODOGIT
  def test_suite
  end
end
