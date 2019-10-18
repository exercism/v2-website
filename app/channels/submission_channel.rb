class SubmissionChannel < ApplicationCable::Channel
  def subscribed
    stream_for submission
  end

  def unsubscribed
  end

  private

  def submission
    @submission ||= Submission.find(params[:id])
  end
end
