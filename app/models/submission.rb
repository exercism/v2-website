class Submission < ApplicationRecord
  belongs_to :solution, polymorphic: true
  has_one :test_run, class_name: "SubmissionTestRun"

  delegate :tests_info, to: :solution

  scope :tested, -> { where(tested: true) }
  scope :successfully_tested, -> {
    tested.joins(:test_run).merge(SubmissionTestRun.successful)
  }

  def broadcast!
    return unless solution.research_experiment_solution?

    BroadcastSubmissionJob.perform_now(self)
  end

  def files
    SubmissionServices::DownloadFiles.(uuid, filenames)
  end

  def ops_status
    SubmissionOpsStatus.new(test_run)
  end
end
