class ProcessNewIterationJob < ApplicationJob
  def perform(iteration)
    UploadIterationToS3.(iteration)
    PubSub::PublishNewIteration.(iteration)
  end
end
