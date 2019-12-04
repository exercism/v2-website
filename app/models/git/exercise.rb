class Git::Exercise
  attr_reader :track, :title, :git_slug, :git_sha
  def initialize(exercise, git_slug, git_sha)
    @track = exercise.track
    @title = exercise.title
    @git_slug = git_slug
    @git_sha = git_sha
  end

  def instructions
    lines = exercise_reader.readme.split("\n")
    lines.shift if /^#\s*#{@title}\s*$/.match? lines.first
    ParseMarkdown.(lines.join("\n"))
  end

  def test_suite
    exercise_reader.tests
  end

  def boilerplate_files
    exercise_reader.boilerplate_files
  end

  private

  def exercise_reader
    @repo_exercise ||= repo.exercise(git_slug, git_sha)
  end

  def repo_url
    track.repo_url
  end

  def repo
    Git::ExercismRepo.new(repo_url)
  end
end
