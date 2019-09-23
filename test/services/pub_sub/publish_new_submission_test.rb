require 'test_helper'

class PublishNewSubmissionTest < ActiveSupport::TestCase

  test "calls to publish_message" do
    submission = create :submission
    PubSub::PublishMessage.expects(:call).with(:new_submission,
      track_slug: submission.solution.exercise.track.slug,
      exercise_slug: submission.solution.exercise.slug,
      submission_id: submission.id
    )
    PubSub::PublishNewSubmission.(submission)
  end
end
