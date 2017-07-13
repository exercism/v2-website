require 'test_helper'

class CreatesDiscussionPostTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      iteration = create :iteration, solution: solution
      user = solution.user
      content = "foobar"

      post = CreatesDiscussionPost.create!(iteration, user, content)

      assert post.persisted?
      assert_equal post.iteration, iteration
      assert_equal post.user, user
      assert_equal post.content, content
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
      assert_nil solution.last_updated_by_mentor_at
    end
  end

  test "creates for mentor" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      iteration = create :iteration, solution: solution
      user = solution.user
      content = "foobar"

      mentor = create :user
      create :solution_mentorship, solution: solution, user: mentor

      post = CreatesDiscussionPost.create!(iteration, mentor, content)

      assert post.persisted?
      assert_equal post.iteration, iteration
      assert_equal post.user, mentor
      assert_equal post.content, content
      assert_nil solution.last_updated_by_user_at
      assert_equal DateTime.now.to_i, solution.last_updated_by_mentor_at.to_i
    end
  end

  test "notifies and emails mentors upon user post" do
    iteration = create :iteration
    solution = iteration.solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    mentor2 = create :user
    create :solution_mentorship, solution: solution, user: mentor1
    create :solution_mentorship, solution: solution, user: mentor2

    CreatesNotification.expects(:create!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_discussion_post_for_mentor, args[1]
      assert_equal "#{user.name} has posted a comment on a solution you are mentoring", args[2]
      assert_equal "http://foobar.com", args[3]
      assert_equal DiscussionPost, args[4][:about].class
    end

    DeliversEmail.expects(:deliver!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_discussion_post_for_mentor, args[1]
      assert_equal DiscussionPost, args[2].class
    end

    CreatesDiscussionPost.create!(iteration, user, "foooebar")
  end

  test "notifies and emails user upon mentor post" do
    iteration = create :iteration
    solution = iteration.solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    mentor2 = create :user
    create :solution_mentorship, solution: solution, user: mentor1
    create :solution_mentorship, solution: solution, user: mentor2

    CreatesNotification.expects(:create!).with do |*args|
      assert_equal user, args[0]
      assert_equal :new_discussion_post, args[1]
      assert_equal "#{user.name} has commented on your solution", args[2]
      assert_equal "http://foobar123.com", args[3]
      assert_equal DiscussionPost, args[4][:about].class
    end

    DeliversEmail.expects(:deliver!).with do |*args|
      assert_equal user, args[0]
      assert_equal :new_discussion_post, args[1]
      assert_equal DiscussionPost, args[2].class
    end

    CreatesDiscussionPost.create!(iteration, mentor1, "foooebar")
  end
end
