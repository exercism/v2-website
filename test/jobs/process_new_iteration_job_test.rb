require 'test_helper'

class ProcessNewIterationJobTest < ActiveJob::TestCase
  setup do
    UploadIterationToS3.stubs(:call)
    PubSub::PublishNewIteration.stubs(:call)
    LockSolution.stubs(:call)
  end

  test "fans out correctly" do
    system_user = create :system_user
    iteration = create :iteration

    UploadIterationToS3.expects(:call).with(iteration)
    PubSub::PublishNewIteration.expects(:call).with(iteration)

    ProcessNewIterationJob.perform_now(iteration)
  end

  test "locks for auto analysis if appropriate" do
    system_user = create :system_user
    iteration = create :iteration
    iteration.solution.stubs(use_auto_analysis?: true)

    LockSolution.expects(:call).with(system_user, iteration.solution, lock_length: 60.minutes)
    ProcessNewIterationJob.perform_now(iteration)
  end

  test "does not lock if auto analysis not appropriate" do
    iteration = create :iteration
    iteration.solution.stubs(use_auto_analysis?: false)

    LockSolution.expects(:call).never
    ProcessNewIterationJob.perform_now(iteration)
  end
end
