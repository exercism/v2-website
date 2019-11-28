require 'test_helper'

module SubmissionServices
  class RunTestsTest < ActiveSupport::TestCase

    test "calls to publish_message" do
      submission = create :submission
      RestClient.expects(:post).with('http://test-runner.example.com/submissions',
        track_slug: submission.solution.exercise.track.slug,
        exercise_slug: submission.solution.exercise.slug,
        submission_uuid: submission.uuid
      )
      RunTests.(submission.uuid, submission.solution)
    end
  end
end
