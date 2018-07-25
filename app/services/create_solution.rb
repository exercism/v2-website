class CreateSolution
  include Mandate

  attr_reader :user, :exercise
  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def call
    Solution.create!(
      user: user,
      exercise: exercise,
      git_sha: git_sha,
      git_slug: exercise.slug,
      last_updated_by_user_at: Time.now
    )
  rescue ActiveRecord::RecordNotUnique
    Solution.find_by(user: user, exercise: exercise)
  end

  private

  memoize
  def git_sha
    Git::ExercismRepo.current_head(repo_url)
  end

  memoize
  def repo_url
    exercise.track.repo_url
  end
end
