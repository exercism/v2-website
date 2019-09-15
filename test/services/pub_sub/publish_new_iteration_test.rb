require 'test_helper'

class PublishNewIterationTest < ActiveSupport::TestCase

  test "calls to publish_message" do
    iteration = create :iteration
    PubSub::PublishMessage.expects(:call).with(:new_iteration,
      track_slug: iteration.solution.exercise.track.slug,
      exercise_slug: iteration.solution.exercise.slug,
      iteration_id: iteration.id
    )
    PubSub::PublishNewIteration.(iteration)
  end
end


