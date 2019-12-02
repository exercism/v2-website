class Submission < ApplicationRecord
  belongs_to :solution, polymorphic: true
  has_one :test_results, class_name: "SubmissionTestResults"

  def status
    return :queued if test_results.nil?

    test_results.pass? ? :passed : :failed
  end

  def broadcast!
    BroadcastSubmissionJob.perform_now(self)
  end

  def files
    SubmissionServices::DownloadFiles.(uuid, filenames)
  end
end
