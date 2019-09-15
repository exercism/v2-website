require 'test_helper'

class RemindAboutSolutionTest < ActiveSupport::TestCase
  test "works with solution" do
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute

      DeliverEmail.expects(:call).with(user, :remind_about_solution, solution, [])
      RemindAboutSolution.(solution)

      solution.reload
      assert_equal Time.now.to_i, solution.reminder_sent_at.to_i
    end
  end

  test "correctly finds other solutions" do
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute

      s1 = create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute
      s2 = create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute
      create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute, completed_at: Time.now
      create :solution, user: user, last_updated_by_mentor_at: Time.now - 1.minute,  last_updated_by_user_at: Time.now

      DeliverEmail.expects(:call).with(user, :remind_about_solution, solution, [s1,s2])
      RemindAboutSolution.(solution)

      solution.reload
      assert_equal Time.now.to_i, solution.reminder_sent_at.to_i
    end
  end

  test "doesn't do anything if the user has actioned it" do
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, last_updated_by_mentor_at: Time.now - 1.minute,  last_updated_by_user_at: Time.now

      DeliverEmail.expects(:call).never
      RemindAboutSolution.(solution)
    end
  end

  test "doesn't do anything if the user has completed it" do
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute, completed_at: Time.now

      DeliverEmail.expects(:call).never
      RemindAboutSolution.(solution)
    end
  end

  test "doesn't do anything if the reminder has already been sent" do
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, reminder_sent_at: Time.now

      DeliverEmail.expects(:call).never
      RemindAboutSolution.(solution)
    end
  end

  test "doesn't sent more than once per day" do
    Timecop.freeze do
      user = create :user
      create :user_email_log, user: user, remind_about_solution_sent_at: Time.current - 23.hours
      solution = create :solution, user: user, last_updated_by_mentor_at: Time.now,  last_updated_by_user_at: Time.now - 1.minute

      DeliverEmail.expects(:call).never
      RemindAboutSolution.(solution)
    end
  end
end
