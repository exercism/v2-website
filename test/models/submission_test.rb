require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  test "#pass? delegates to test run" do
    submission = build(:submission)
    test_run = build(:submission_test_run)
    test_run.stubs(:pass?).returns(true)
    submission.test_run = test_run

    assert submission.pass?
  end
end
