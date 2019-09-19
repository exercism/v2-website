class ProcessNewSubmissionJob < ApplicationJob
  def perform(submission)
    UploadSubmissionToS3.(submission)
    PubSub::PublishNewSubmission.(submission)
  end
end

