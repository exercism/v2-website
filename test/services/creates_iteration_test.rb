require 'test_helper'

class CreatesIterationTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    solution = create :solution
    code = "foobar"

    iteration = CreatesIteration.create!(solution, code)

    assert iteration.persisted?
    assert_equal iteration.solution, solution
    assert_equal iteration.code, code
  end

  test "updates last updated by" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      assert_nil solution.last_updated_by_user_at

      CreatesIteration.create!(solution, "Foobar")
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
    end
  end

  test "set all mentors' requires_action to true" do
    solution = create :solution
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: solution, requires_action: false

    CreatesIteration.create!(solution, "Foobar")

    mentorship.reload
    assert mentorship.requires_action
  end

  test "notifies and emails mentors" do
    solution = create :solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    mentor2 = create :user
    create :solution_mentorship, solution: solution, user: mentor1
    create :solution_mentorship, solution: solution, user: mentor2

    CreatesNotification.expects(:create!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_iteration_for_mentor, args[1]
      assert_equal "#{user.name} has posted a new iteration on a solution you are mentoring", args[2]
      assert_equal "http://foobar.com", args[3]
      assert_equal Iteration, args[4][:about].class
    end

    DeliversEmail.expects(:deliver!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_iteration_for_mentor, args[1]
      assert_equal Iteration, args[2].class
    end

    CreatesIteration.create!(solution, "foooebar")
  end


end

