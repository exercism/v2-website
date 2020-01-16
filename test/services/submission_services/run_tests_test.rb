require 'test_helper'

module SubmissionServices
  class RunTestsTest < ActiveSupport::TestCase

    test "calls to publish_message" do
      submission = create :submission
      RestClient.expects(:post).with('http://test-runner.example.com/submissions',
        submission_uuid: submission.uuid,
        language_slug: submission.solution.exercise.track.slug,
        exercise_slug: submission.solution.exercise.slug
      )
      RunTests.(submission.uuid, submission.solution)
    end

    test "uses language_track" do
      research_track = create :track, slug: "research_123"
      ruby_track = create :track, slug: "ruby"
      exercise = create :exercise, track: research_track, slug: "ruby-1-b"

      submission = create :submission, solution: create(:research_experiment_solution, exercise: exercise)

      RestClient.expects(:post).with('http://test-runner.example.com/submissions',
        submission_uuid: submission.uuid,
        language_slug: ruby_track.slug,
        exercise_slug: exercise.slug
      )
      RunTests.(submission.uuid, submission.solution)
    end
  end
end
