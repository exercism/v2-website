class GitExercise
  attr_reader :track, :exercise, :git_sha
  def initialize(exercise, git_sha)
    @track = exercise.track
    @exercise = exercise
    @git_sha = git_sha
  end

  # TODOGIT
  def solution
  end

  # TODOGIT
  def test_suite
  end
end
