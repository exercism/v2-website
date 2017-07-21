class CreatesSolution
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :user, :exercise
  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def create!
    Solution.create(
      user: user,
      exercise: exercise,
      git_sha: git_sha,
      git_slug: exercise.slug
    )
  end

  private

  def git_sha
    Git::ExercismRepo.new(repo_url).head
  end

  def repo_url
    exercise.track.repo_url
  end
end
