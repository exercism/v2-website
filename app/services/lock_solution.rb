class LockSolution
  include Mandate

  LOCK_LENGTH = 30.minutes

  attr_reader :user, :solution, :force
  def initialize(user, solution, force: false)
    @user = user
    @solution = solution
    @force = force
  end

  def call
    if existing_user_lock
      existing_user_lock.update(locked_until: Time.current + LOCK_LENGTH)
      return existing_user_lock
    end

    unless force
      return false if other_lock_exists?
    end

    create_lock
  end

  private
  def existing_user_lock
    SolutionLock.where(user: user).
                 where(solution: solution).
                 where("locked_until > ?", Time.current).
                 first
  end

  def other_lock_exists?
    SolutionLock.where.not(user: user).
                 where(solution: solution).
                 where("locked_until > ?", Time.current).
                 exists?
  end

  def create_lock
    SolutionLock.create!(
      user: user,
      solution: solution,
      locked_until: Time.current + LOCK_LENGTH
    )
  end
end
