class SubmissionTestResults < ApplicationRecord
  belongs_to :submission

  def results_status
    super.try(&:to_sym)
  end

end
