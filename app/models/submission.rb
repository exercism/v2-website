class Submission < ApplicationRecord
  belongs_to :solution
  has_one :test_results, class_name: "SubmissionTestResults"
end
