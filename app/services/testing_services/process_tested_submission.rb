module TestingServices
  class ProcessTestedSubmission
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

      status = if submission.tested?
                 submission.test_results.last.results_status
               else
                 :failed_dependency
               end

      message = submission.test_results.last.message if status == :error
      failure = submission.test_results.last.tests.select{|t|t['status'] == 'fail'}.first if status == :fail

      SubmissionChannel.broadcast_to(
        submission,
        status: status,
        message: message,
        failure: failure
      )
    end

    private
    attr_reader :submission, :ops_status, :results
  end
end
