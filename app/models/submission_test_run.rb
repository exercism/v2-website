class SubmissionTestRun < ApplicationRecord
  belongs_to :submission

  delegate :solution, :tests_info, to: :submission

  def results_status
    super.try(&:to_sym)
  end

  def pass?
    results_status == :pass
  end

  def errored?
    results_status == :error
  end

  def failed?
    results_status == :fail
  end

  def tests
    Array(super).map { |test| SubmissionTestRunResult.new(solution, test) }
  end

  def tests_to_display(order = tests_info)
    ordered_tests = order.reorder(tests)

    limit = ordered_tests.index(&:failed?)

    ordered_tests[0..limit]
  end

  def to_partial_path
    return "research/submission_test_runs/no_results" if results_status.nil?

    "research/submission_test_runs/#{results_status}"
  end
end
