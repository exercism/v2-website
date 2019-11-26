class SubmissionChannel < ApplicationCable::Channel
  def subscribed
    stream_for submission
  end

  def unsubscribed
  end

  private

  def submission
    @submission ||= Submission.find_by!(uuid: params[:uuid])
  end
end
