require 'test_helper'

class CreatesDiscussionPostTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    iteration = create :iteration
    user = iteration.solution.user
    content = "foobar"

    post = CreatesDiscussionPost.create!(iteration, user, content)

    assert post.persisted?
    assert_equal post.iteration, iteration
    assert_equal post.user, user
    assert_equal post.content, content
  end

  test "notifies and emails mentors upon user post" do
    iteration = create :iteration
    solution = iteration.solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    mentor2 = create :user
    create :discussion_post, iteration: iteration, user: mentor1
    create :discussion_post, iteration: iteration, user: mentor2

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
    create :discussion_post, iteration: iteration, user: mentor1
    create :discussion_post, iteration: iteration, user: mentor2

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
