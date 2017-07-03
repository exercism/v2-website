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
      git_sha: git_sha
    )
  end

  private

  # TODOGIT
  # This should be the current sha of the exercise
  def git_sha
    SecureRandom.uuid
  end
end
