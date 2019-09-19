module PubSub
  class PublishNewSubmission
    include Mandate

    initialize_with :submission

    def call
      PublishMessage.(:new_submission, {
        track_slug: submission.solution.exercise.track.slug,
        exercise_slug: submission.solution.exercise.slug,
        submission_id: submission.id
      })
    end
  end
end

