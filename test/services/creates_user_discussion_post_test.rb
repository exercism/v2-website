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
    create :track_mentorship, user: mentor1
    create :track_mentorship, user: mentor2
    create :solution_mentorship, solution: solution, user: mentor1
    create :solution_mentorship, solution: solution, user: mentor2

    CreateNotification.expects(:call).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_discussion_post_for_mentor, args[1]
      assert_equal "<strong>#{user.handle}</strong> has posted a comment on a solution you are mentoring", args[2]
      assert_equal "https://test.exercism.io/mentor/solutions/#{solution.uuid}", args[3]
      assert_equal iteration, args[4][:about]
    end

    DeliverEmail.expects(:call).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_discussion_post_for_mentor, args[1]
      assert_equal DiscussionPost, args[2].class
    end

    CreatesUserDiscussionPost.create!(iteration, user, "foooebar")
  end

  test "does not notify non-current mentors" do
    iteration = create :iteration
    solution = iteration.solution
    user = solution.user

    # Create a user who mentored this solution but doesn't
    # have a current track mentorship so is inactive.
    inactive_mentor = create :user
    create :solution_mentorship, solution: solution, user: inactive_mentor

    CreateNotification.expects(:call).never
    DeliverEmail.expects(:call).never
    CreatesUserDiscussionPost.create!(iteration, user, "foooebar")
  end

  test "set all mentors' requires_action" do
    iteration = create :iteration
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: iteration.solution, requires_action_since: nil

    CreatesUserDiscussionPost.create!(iteration, iteration.solution.user, "Foobar")

    mentorship.reload
    assert mentorship.requires_action?
  end

  test "does not set all mentors' requires_action if approved" do
    solution = create :solution, approved_by: create(:user)
    iteration = create :iteration, solution: solution
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: iteration.solution, requires_action_since: nil

    CreatesUserDiscussionPost.create!(iteration, iteration.solution.user, "Foobar")

    mentorship.reload
    refute mentorship.requires_action?
  end
end
