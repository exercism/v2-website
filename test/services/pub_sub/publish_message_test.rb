require 'test_helper'

class PublishMessageTest < ActiveSupport::TestCase

  test "publishes to propono" do
    topic = mock
    data = mock

    client = mock
    client.expects(:publish).with(topic, data, async: true)
    Propono.expects(:configure_client).returns(client)

    PubSub::PublishMessage.(topic, data)
  end

  test "publishes to propono with async:false" do
    topic = mock
    data = mock

    client = mock
    client.expects(:publish).with(topic, data, async: false)
    Propono.expects(:configure_client).returns(client)

    PubSub::PublishMessage.(topic, data, async: false)
  end
end
