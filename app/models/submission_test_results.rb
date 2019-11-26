class SubmissionTestResults < ApplicationRecord
  belongs_to :submission

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
    super.map { |test| SubmissionTest.new(test) }
  end

  def failed_tests
    tests.select(&:failed?)
  end
end
