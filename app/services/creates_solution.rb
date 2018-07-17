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
      git_slug: exercise.slug,
      last_updated_by_user_at: Time.now
    )
  end

  private

  def git_sha
    Git::ExercismRepo.current_head(repo_url)
  end

  def repo_url
    exercise.track.repo_url
  end
end
