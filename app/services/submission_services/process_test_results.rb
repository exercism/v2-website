module SubmissionServices
  class ProcessTestResults
    include Mandate

    def initialize(submission, ops_status, results)
      @submission = submission
      @ops_status = ops_status.to_s.to_sym
      @results = results.is_a?(Hash) ? results.symbolize_keys : {}
    end

    def call
      SubmissionTestResults.create!(
        submission: submission,
        ops_status: ops_status,
        results_status: results[:status],
        message: results[:message],
        tests: results[:tests],
        results: results
      )
      submission.update!(tested: true)

      submission.broadcast!
    end

    private
    attr_reader :submission, :ops_status, :results
  end
end
