class GitExercise
  attr_reader :track, :exercise, :git_slug, :git_sha
  def initialize(exercise, git_slug, git_sha)
    @track = exercise.track
    @exercise = exercise
    @git_slug = git_slug
    @git_sha = git_sha
  end

  def instructions
    exercise.readme
  end

  def test_suite
    exercise.tests
  end

  private

  def exercise
    repo.exercise(git_slug, git_sha)
  end

  def repo_url
    track.repo_url
  end

  def repo
    Git::ExercismRepo.new(repo_url)
  end
end
