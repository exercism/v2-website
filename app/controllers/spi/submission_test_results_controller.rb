module SPI
  class SubmissionTestResultsController < BaseController
    def create
      submission = Submission.find_by_uuid!(params[:submission_uuid])
      SubmissionServices::ProcessTestResults.(
        submission,
        params[:ops_status],
        params[:ops_message],
        params[:results].permit!.to_h
      )
      render json: {received: :ok}
    end
  end
end
