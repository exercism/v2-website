class Submission < ApplicationRecord
  belongs_to :solution
  has_many :test_results, class_name: "SubmissionTestResults"
end
