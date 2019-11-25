module SPI
  class SubmissionTestResultsController < BaseController
    def create
      submission = Submission.find_by_uuid!(params[:submission_uuid])
      SubmissionServices::ProcessTestResults.(
        submission,
        params[:status],
        JSON.parse(params[:results])
      )
      render json: {received: :ok}
    end
  end
end
