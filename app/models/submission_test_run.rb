class SubmissionTestRun < ApplicationRecord
  belongs_to :submission

  delegate :solution, :tests_info, to: :submission

  serialize :tests, Array

  scope :successful, -> { where(ops_status: 200) }

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

  def num_passed_tests
    passed_tests.length
  end

  def passed_tests
    test_results.select(&:passed?)
  end

  def num_failed_tests
    failed_tests.length > 0 ? 1 : 0
  end

  def failed_tests
    test_results.select(&:failed?) + test_results.select(&:errored?)
  end

  def num_skipped_tests
    num_fails = test_results.select(&:failed?).length
    num_fails < 2 ? 0 : num_fails - 1
  end

  def test_results
    formatted_tests = tests.map do |test|
      test_info = tests_info.find { |info| info.test == test["name"] }

      SubmissionTestRunResult.new(test_info, test)
    end
  end

  def tests_to_display(order = tests_info)
    ordered_tests = order.reorder(test_results)

    [ordered_tests.select(&:passed?), ordered_tests.find(&:failed?)].
      compact.
      flatten
  end

  def to_partial_path
    return "research/submission_test_runs/no_results" if results_status.nil?

    "research/submission_test_runs/#{results_status}"
  end
end
