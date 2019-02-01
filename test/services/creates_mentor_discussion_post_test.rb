require 'test_helper'

class CreatesMentorDiscussionPostTest < ActiveSupport::TestCase
  test "creates for mentor" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      iteration = create :iteration, solution: solution
      user = solution.user
      content = "foobar"

      mentor = create :user
      create :track_mentorship, user: mentor, track: solution.exercise.track
      create :solution_mentorship, solution: solution, user: mentor

      post = CreatesMentorDiscussionPost.create!(iteration, mentor, content)

      assert post.persisted?
      assert_equal post.iteration, iteration
      assert_equal post.user, mentor
      assert_equal post.content, content
      assert_nil solution.last_updated_by_user_at
      assert_equal DateTime.now.to_i, solution.last_updated_by_mentor_at.to_i
    end
  end

  test "fails for non-mentor" do
    refute CreatesMentorDiscussionPost.create!(create(:iteration), create(:user), "foobar")
  end

  test "fails for mentor of different track" do
    user = create :user
    create :track_mentorship, user: user
    refute CreatesMentorDiscussionPost.create!(create(:iteration), user, "foobar")
  end

  test "notifies and emails user upon mentor post" do
    iteration = create :iteration
    solution = iteration.solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    create :track_mentorship, user: mentor1, track: solution.exercise.track
    create :solution_mentorship, solution: solution, user: mentor1

    CreateNotification.expects(:call).with do |*args|
      assert_equal user, args[0]
      assert_equal :new_discussion_post, args[1]
      assert_equal "<strong>#{mentor1.handle}</strong> has commented on your solution to <strong>#{solution.exercise.title}</strong> on the <strong>#{solution.exercise.track.title}</strong> track.", args[2]
      assert_equal "https://test.exercism.io/my/solutions/#{solution.uuid}/iterations/#{iteration.id}", args[3]
      assert_equal DiscussionPost, args[4][:trigger].class
      assert_equal iteration, args[4][:about]
    end

    DeliverEmail.expects(:call).with do |*args|
      assert_equal user, args[0]
      assert_equal :new_discussion_post, args[1]
      assert_equal DiscussionPost, args[2].class
    end

    CreatesMentorDiscussionPost.create!(iteration, mentor1, "foooebar")
  end

  test "creates solution_mentorship" do
    iteration = create :iteration
    mentor = create :user
    create :track_mentorship, user: mentor, track: iteration.solution.exercise.track

    CreateSolutionMentorship.expects(:call).with(iteration.solution, mentor).returns(mock(update!: false))
    CreatesMentorDiscussionPost.create!(iteration, mentor, "Foobar")
  end

  test "cancels a mentor's requires_action when they post" do
    iteration = create :iteration
    mentor = create :user
    create :track_mentorship, user: mentor, track: iteration.solution.exercise.track
    mentorship = create :solution_mentorship, user: mentor, solution: iteration.solution, requires_action_since: Time.current

    CreatesMentorDiscussionPost.create!(iteration, mentor, "Foobar")

    mentorship.reload
    refute mentorship.requires_action?
  end
end
