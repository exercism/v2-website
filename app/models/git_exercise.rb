class GitExercise
  attr_reader :track, :git_slug, :git_sha
  def initialize(exercise, git_slug, git_sha)
    @track = exercise.track
    @git_slug = git_slug
    @git_sha = git_sha
  end

  def instructions
    ParsesMarkdown.parse(repo_exercise.readme)
  end

  def test_suite
    repo_exercise.tests
  end

  private

  def repo_exercise
    @repo_exercise ||= repo.exercise(git_slug, git_sha)
  end

  def repo_url
    track.repo_url
  end

  def repo
    Git::ExercismRepo.new(repo_url)
  end
end
