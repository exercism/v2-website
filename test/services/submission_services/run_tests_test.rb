require 'test_helper'

module SubmissionServices
  class RunTestsTest < ActiveSupport::TestCase

    test "calls to publish_message" do
      submission = create :submission
      RestClient.expects(:post).with('http://test-runner.example.com/submissions',
        submission_uuid: submission.uuid,
        language_slug: submission.solution.exercise.track.slug,
        exercise_slug: submission.solution.exercise.slug,
        version_slug: nil
      )
      RunTests.(submission.uuid, submission.solution)
    end

    test "uses version_slug" do
      submission = create :submission
      version_slug = SecureRandom.uuid

      RestClient.expects(:post).with('http://test-runner.example.com/submissions',
        submission_uuid: submission.uuid,
        language_slug: submission.solution.exercise.track.slug,
        exercise_slug: submission.solution.exercise.slug,
        version_slug: version_slug
      )
      RunTests.(submission.uuid, submission.solution, version_slug)
    end

  end
end
