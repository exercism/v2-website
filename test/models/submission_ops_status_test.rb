require 'test_helper'

class SubmissionOpsStatusTest < ActiveSupport::TestCase
  test "#status returns :pass when test run passed" do
    test_run = stub(ops_status: 200, pass?: true)

    ops_status = SubmissionOpsStatus.new(test_run)

    assert_equal :pass, ops_status.status
  end

  test "#status returns :fail when test run failed" do
    test_run = stub(ops_status: 200, pass?: false)

    ops_status = SubmissionOpsStatus.new(test_run)

    assert_equal :fail, ops_status.status
  end

  test "#status returns :error when test run errored" do
    test_run = stub(ops_status: 500)

    ops_status = SubmissionOpsStatus.new(test_run)

    assert_equal :error, ops_status.status
  end

  test "#status returns :queued for no test run" do
    ops_status = SubmissionOpsStatus.new(nil)

    assert_equal :queued, ops_status.status
  end
end
