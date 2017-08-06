require 'test_helper'

class CreatesUserDiscussionPostTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      iteration = create :iteration, solution: solution
      user = solution.user
      content = "foobar"

      post = CreatesUserDiscussionPost.create!(iteration, user, content)

      assert post.persisted?
      assert_equal post.iteration, iteration
      assert_equal post.user, user
      assert_equal post.content, content
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
      assert_nil solution.last_updated_by_mentor_at
    end
  end

  test "notifies and emails mentors" do
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
      assert_equal "https://exercism.io/mentor/solutions/#{solution.uuid}", args[3]
      assert_equal solution, args[4][:about]
    end

    DeliversEmail.expects(:deliver!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_discussion_post_for_mentor, args[1]
      assert_equal DiscussionPost, args[2].class
    end

    CreatesUserDiscussionPost.create!(iteration, user, "foooebar")
  end

  test "set all mentors' requires_action" do
    iteration = create :iteration
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: iteration.solution, requires_action: false

    CreatesUserDiscussionPost.create!(iteration, iteration.solution.user, "Foobar")

    mentorship.reload
    assert mentorship.requires_action
  end
end
