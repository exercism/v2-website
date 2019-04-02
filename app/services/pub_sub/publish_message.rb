module PubSub
  class PublishMessage
    include Mandate

    attr_reader :topic, :data, :async
    def initialize(topic, data, async: true)
      @topic = topic
      @data = data
      @async = async
    end

    def call
      client.publish(topic, data, async: async)
    end

    private
    def client
      @client ||= Propono.configure_client
    end
  end
end
