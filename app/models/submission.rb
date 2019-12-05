class Submission < ApplicationRecord
  belongs_to :solution, polymorphic: true
  has_one :test_run, class_name: "SubmissionTestRun"

  def status
    return :queued if test_run.nil?

    test_run.pass? ? :passed : :failed
  end

  def broadcast!
    BroadcastSubmissionJob.perform_now(self)
  end

  def files
    SubmissionServices::DownloadFiles.(uuid, filenames)
  end
end
