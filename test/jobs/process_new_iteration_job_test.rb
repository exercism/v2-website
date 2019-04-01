require 'test_helper'

class ProcessNewIterationJobTest < ActiveJob::TestCase
  test "fans out correctly" do
    iteration = create :iteration

    UploadIterationToS3.expects(:call).with(iteration)
    PubSub::PublishNewIteration.expects(:call).with(iteration)

    ProcessNewIterationJob.perform_now(iteration)
  end
end
