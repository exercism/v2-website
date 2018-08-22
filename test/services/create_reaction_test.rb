require 'test_helper'

class CreatesReactionTest < ActiveSupport::TestCase
  test "creates reaction" do
    user = create :user
    solution = create :solution
    emotion = 'love'

    CreateNotification.expects(:call).with do |*args|
      assert_equal solution.user, args[0]
      assert_equal :new_reaction, args[1]
      assert_equal "<strong>#{user.handle}</strong> has reacted to your solution to <strong>#{solution.exercise.title}</strong> on the <strong>#{solution.exercise.track.title}</strong> track.", args[2]
      assert_equal "https://test.exercism.io/solutions/#{solution.uuid}", args[3]
      assert_equal Reaction, args[4][:trigger].class
      assert_equal solution, args[4][:about]
    end

    reaction = CreateReaction.(user, solution, emotion)
    solution.reload

    assert_equal 1, solution.reactions.count
    assert reaction.persisted?
    assert_equal solution, reaction.solution
    assert_equal user, reaction.user
    assert_equal emotion, reaction.emotion
    assert_equal 1, solution.num_reactions
  end

  test "updates reaction" do
    user = create :user
    solution = create :solution, num_reactions: 1
    original_reaction = create :reaction, user: user, solution: solution, emotion: 'like'
    emotion = 'genius'
    reaction = CreateReaction.(user, solution, emotion)
    solution.reload

    assert_equal original_reaction, reaction
    assert_equal 1, solution.reactions.count
    assert reaction.persisted?
    assert_equal solution, reaction.solution
    assert_equal user, reaction.user
    assert_equal emotion, reaction.emotion
    assert_equal 1, solution.num_reactions
  end

  test "destroys reaction" do
    user = create :user
    solution = create :solution
    emotion = 'genius'
    original_reaction = create :reaction, user: user, solution: solution, emotion: emotion, comment: ""
    CreateReaction.(user, solution, emotion)
    solution.reload

    assert_equal 0, solution.reactions.count
    assert_equal 0, solution.num_reactions
  end

  test "destroys reaction and notifications" do
    user = create :user
    solution = create :solution
    emotion = 'genius'
    reaction = create :reaction, user: user, solution: solution, emotion: emotion, comment: ""
    other_notification = create :notification, user: solution.user
    notification = create :notification, user: solution.user, type: :new_reaction, trigger: reaction

    CreateReaction.(user, solution, emotion)

    solution.user.reload
    assert_equal [other_notification], solution.user.notifications
  end

  test "does not destroy if there is a comment" do
    user = create :user
    solution = create :solution, num_reactions: 1
    emotion = 'genius'
    original_reaction = create :reaction, user: user, solution: solution, emotion: emotion, comment: "Foobar"
    reaction = CreateReaction.(user, solution, emotion)
    solution.reload

    assert_equal original_reaction, reaction
    assert_equal 1, solution.reactions.count
    assert reaction.persisted?
    assert_equal solution, reaction.solution
    assert_equal user, reaction.user
    assert_equal emotion, reaction.emotion
    assert_equal 1, solution.num_reactions
  end
end
