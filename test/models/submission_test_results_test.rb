require 'test_helper'

class SubmissionTestResultsTest < ActiveSupport::TestCase
  test "#pass? returns true when #results_status is :pass" do
    result = build(:submission_test_result, results_status: "pass")

    assert result.pass?
  end

  test "#pass? returns false when #results_status is not :pass" do
    result = build(:submission_test_result, results_status: "fail")

    refute result.pass?
  end
end
