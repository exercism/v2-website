require 'test_helper'

class LockSolutionTest < ActiveSupport::TestCase
  test "creates in the normal case" do
    Timecop.freeze do
      user = create :user
      solution = create :solution
      assert LockSolution.(user, solution)
      assert SolutionLock.where(
        user: user,
        solution: solution,
        locked_until: Time.current + 30.minutes
      ).exists?
    end
  end

  test "creates for expired lock" do
    Timecop.freeze do
      user = create :user
      solution = create :solution
      create :solution_lock, solution: solution, locked_until: Time.current - 5.minutes

      assert LockSolution.(user, solution)
      assert SolutionLock.where(
        user: user,
        solution: solution,
        locked_until: Time.current + 30.minutes
      ).exists?
    end
  end

  test "returns true and updates locked_until for same user" do
    Timecop.freeze do
      user = create :user
      solution = create :solution
      lock = create :solution_lock, solution: solution, user: user, locked_until: Time.current + 10.minutes

      assert LockSolution.(user, solution)
      lock.reload

      assert_equal (Time.current + 30.minutes).to_i, lock.locked_until.to_i
      assert_equal 1, SolutionLock.where(
        user: user,
        solution: solution
      ).count
    end
  end

  test "returns false if a lock exists" do
    Timecop.freeze do
      user = create :user
      solution = create :solution
      create :solution_lock, solution: solution, locked_until: Time.current + 5.minutes

      refute LockSolution.(user, solution)
      refute SolutionLock.where(
        user: user,
        solution: solution,
        locked_until: Time.current + 30.minutes
      ).exists?
    end
  end

  test "creates if a lock exists but force: true" do
    Timecop.freeze do
      user = create :user
      solution = create :solution
      create :solution_lock, solution: solution, locked_until: Time.current + 5.minutes

      assert LockSolution.(user, solution, force: true)
      assert SolutionLock.where(
        user: user,
        solution: solution,
        locked_until: Time.current + 30.minutes
      ).exists?
    end
  end

  test "we avoid race conditions" do
    # This doesn't really matter and I've decided that table locking isn't
    # work the pain of DB performance, as we really only want to lock for
    # one solution, not the whole table. But this test code works if we
    # ever want to do this properly in the future.
    skip

    Timecop.freeze do
      user1 = create :user
      user2 = create :user
      solution = create :solution

      # If we check for the other lock then no-one should be able to write
      # to that table before we create it, so in the situation below, the
      # first solution should be true and the second should be false
      # The StubbedLockSolution has a pause of 1s between the checking
      # and the creation
      t1 = Thread.new { StubbedLockSolution.(user1, solution) }
      t2 = Thread.new { sleep(0.1); LockSolution.(user2, solution) }
      t1.join
      t2.join

      assert SolutionLock.where(
        user: user1,
        solution: solution,
        locked_until: Time.current + 30.minutes
      ).exists?

      refute SolutionLock.where(
        user: user2,
        solution: solution,
        locked_until: Time.current + 30.minutes
      ).exists?
    end
  end

  class StubbedLockSolution < LockSolution
    def other_lock_exists?
      s = super
      sleep(0.4)
      return s
    end
  end
end
