require 'test_helper'

class ProcessNewSubmissionJobTest < ActiveJob::TestCase
  setup do
    UploadSubmissionToS3.stubs(:call)
    PubSub::PublishNewSubmission.stubs(:call)
  end

  test "fans out correctly" do
    system_user = create :user, :system
    submission = create :submission

    UploadSubmissionToS3.expects(:call).with(submission)
    PubSub::PublishNewSubmission.expects(:call).with(submission)

    ProcessNewSubmissionJob.perform_now(submission)
  end
end
