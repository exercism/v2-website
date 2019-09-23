class Submission < ApplicationRecord
  has_many_attached :files

  belongs_to :solution
  has_many :test_results, class_name: "SubmissionTestResults"
end
