module SPI
  class SubmissionTestRunsController < BaseController
    def create
      submission = Submission.find_by_uuid!(params[:submission_uuid])
      SubmissionServices::ProcessTestRun.(
        submission,
        params[:ops_status],
        params[:ops_message],
        params[:results].try {|r| r.permit!.to_h }
      )
      render json: {received: :ok}
    end
  end
end
