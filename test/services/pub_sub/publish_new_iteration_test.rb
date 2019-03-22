require 'test_helper'

class PublishNewIterationTest < ActiveSupport::TestCase

  test "calls to publish_message" do
    iteration = create :iteration
    PubSub::PublishMessage.expects(:call).with(:new_iteration, {id: iteration.id})
    PubSub::PublishNewIteration.(iteration)
  end
end


