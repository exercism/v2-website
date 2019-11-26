class SolutionChannel < ApplicationCable::Channel
  def subscribed
    stream_for solution
  end

  def unsubscribed
  end

  private

  def solution
    @solution ||= Solution.find(params[:id])
  end
end
