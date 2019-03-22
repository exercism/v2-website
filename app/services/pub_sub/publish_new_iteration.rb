module PubSub
  class PublishNewIteration
    include Mandate

    initialize_with :iteration

    def call
      PublishMessage.(:new_iteration, id: iteration.id)
    end
  end
end
