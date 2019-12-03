class ResearchSolutionChannel < ApplicationCable::Channel
  def subscribed
    stream_for solution
  end

  def unsubscribed
  end

  def create_submission(submission)
    uuid = SecureRandom.uuid

    SubmissionServices::Create.(uuid, solution, submission["files"])
  end

  private

  def solution
    @solution ||= Research::ExperimentSolution.find(params[:id])
  end
end
