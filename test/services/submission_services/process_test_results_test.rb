require 'test_helper'

module SubmissionServices
  class ProcessTestResultsTest < ActiveSupport::TestCase
    test "works with results" do
      submission = create :submission
      ops_status = 200
      results_status = "pass"
      message = "Something happened"
      tests = [{'foo' => 'bar'}]
      results = {
        "status" => results_status,
        "message" => message,
        "tests" => tests
      }

      ProcessTestResults.(submission, ops_status, nil, results)
      tr = SubmissionTestResults.last
      assert_equal submission, tr.submission
      assert_equal ops_status, tr.ops_status
      assert_nil tr.ops_message
      assert_equal results_status.to_sym, tr.results_status
      assert_equal message, tr.message
      assert_equal tests, tr.tests
      assert_equal results, tr.results

      assert submission.reload.tested
    end

    test "works with no results" do
      submission = create :submission
      ops_status = 104
      ops_message = "Some error happened"

      ProcessTestResults.(submission, ops_status, ops_message, nil)
      tr = SubmissionTestResults.last
      assert_equal submission, tr.submission
      assert_equal ops_status, tr.ops_status
      assert_equal ops_message, tr.ops_message
      assert_nil tr.results_status
      assert_nil tr.message
      assert_nil tr.tests
      assert_equal({}, tr.results)

      assert submission.reload.tested
    end

    test "works with long error message" do
      submission = create :submission
      ops_status = 200

      message = 10000.times.map{'a'}.join

      ProcessTestResults.(submission, ops_status, nil, {"message": message})
      tr = SubmissionTestResults.last
      assert_equal submission, tr.submission
      assert_equal ops_status, tr.ops_status
      assert_equal message, tr.message

      assert submission.reload.tested
    end
  end
end
