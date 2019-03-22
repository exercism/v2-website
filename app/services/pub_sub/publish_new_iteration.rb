module PubSub
  class PublishNewIteration
    include Mandate

    initialize_with :iteration

    def call
      PublishMessage.(:new_iteration, {
        track_slug: iteration.solution.exercise.track.slug,
        id: iteration.id
      })
    end
  end
end
