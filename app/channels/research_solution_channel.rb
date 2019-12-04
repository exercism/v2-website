class ResearchSolutionChannel < ApplicationCable::Channel
  def subscribed
    stream_for solution
  end

  def unsubscribed
  end

  def create_submission(data)
    uuid = SecureRandom.uuid

    SubmissionServices::Create.(uuid, solution, data["submission"])
  end

  private

  def solution
    @solution ||= Research::ExperimentSolution.find(params[:id])
  end
end
