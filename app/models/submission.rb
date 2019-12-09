class Submission < ApplicationRecord
  belongs_to :solution, polymorphic: true
  has_one :test_run, class_name: "SubmissionTestRun"

  delegate :tests_info, to: :solution

  def broadcast!
    BroadcastSubmissionJob.perform_now(self)
  end

  def files
    SubmissionServices::DownloadFiles.(uuid, filenames)
  end

  def ops_status
    SubmissionOpsStatus.new(test_run)
  end
end
