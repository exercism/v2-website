class ProcessNewIterationJob < ApplicationJob
  def perform(iteration)
    UploadIterationToS3.(iteration)

=begin
    PubSub::PublishNewIteration.(iteration)

    if iteration.solution.use_auto_analysis?
      LockSolution.(
        User.system_user,
        iteration.solution,
        lock_length: 60.minutes
      )
    end
  end
=end
end
