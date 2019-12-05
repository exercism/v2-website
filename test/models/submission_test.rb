require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "#status is queued when there are no test results" do
    submission = create(:submission)

    assert_equal :queued, submission.status
  end

  test "#status is passed when test results pass" do
    submission = create(:submission)
    test_run = create(:submission_test_run, submission: submission)
    test_run.stubs(:pass?).returns(true)
    submission.test_run = test_run

    assert_equal :passed, submission.status
  end

  test "#status is failed when test results failed" do
    submission = create(:submission)
    test_run = create(:submission_test_run, submission: submission)
    test_run.stubs(:pass?).returns(false)
    submission.test_run = test_run

    assert_equal :failed, submission.status
  end
end
