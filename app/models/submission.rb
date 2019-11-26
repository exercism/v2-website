class Submission < ApplicationRecord
  belongs_to :solution
  has_one :test_results, class_name: "SubmissionTestResults"

  delegate :broadcast!, to: :solution

  def status
    return :queued if test_results.nil?

    test_results.pass? ? :passed : :failed
  end
end
