require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "#status is queued when there are no test results" do
    submission = create(:submission)

    assert_equal :queued, submission.status
  end

  test "#status is passed when test results pass" do
    submission = create(:submission)
    test_results = create(:submission_test_result, submission: submission)
    test_results.stubs(:pass?).returns(true)
    submission.test_results = test_results

    assert_equal :passed, submission.status
  end

  test "#status is failed when test results failed" do
    submission = create(:submission)
    test_results = create(:submission_test_result, submission: submission)
    test_results.stubs(:pass?).returns(false)
    submission.test_results = test_results

    assert_equal :failed, submission.status
  end
end
