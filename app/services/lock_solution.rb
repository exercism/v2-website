class LockSolution
  include Mandate

  attr_reader :user, :solution, :force, :lock_length
  def initialize(user, solution, force: false, lock_length: DEFAULT_LOCK_LENGTH)
    @user = user
    @solution = solution
    @force = force
    @lock_length = lock_length
  end

  def call
    if existing_user_lock
      existing_user_lock.update(locked_until: Time.current + lock_length)
      return existing_user_lock
    end

    return false if !force && other_lock_exists?

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
      locked_until: Time.current + lock_length
    )
  end

  DEFAULT_LOCK_LENGTH = 30.minutes
  private_constant :DEFAULT_LOCK_LENGTH
end
