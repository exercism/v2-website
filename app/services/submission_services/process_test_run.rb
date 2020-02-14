module SubmissionServices
  class ProcessTestRun
    include Mandate

    def initialize(submission, ops_status, ops_message, results)
      @submission = submission
      @ops_status = ops_status.to_i
      @ops_message = ops_message
      @results = results.is_a?(Hash) ? results.symbolize_keys : {}
    end

    def call
      SubmissionTestRun.create!(
        submission: submission,
        ops_status: ops_status,
        ops_message: ops_message,
        results_status: results[:status],
        message: results[:message],
        tests: results[:tests],
        results: results
      )
      submission.update!(tested: true)

      submission.broadcast!
    end

    private
    attr_reader :submission, :ops_status, :ops_message, :results
  end
end
