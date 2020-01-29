require 'test_helper'

module SubmissionServices
  class ProcessTestRunTest < ActiveSupport::TestCase
    test "works with results" do
      skip # TODO: TEST RUN

      submission = create :submission
      ops_status = 200
      results_status = "pass"
      message = "Something happened"
      tests = [{
        "name" => "OneWordWithOneVowel",
        "status" => "pass"
      }]
      results = {
        "status" => results_status,
        "message" => message,
        "tests" => tests
      }

      ProcessTestRun.(submission, ops_status, nil, results)
      tr = SubmissionTestRun.last
      assert_equal submission, tr.submission
      assert_equal ops_status, tr.ops_status
      assert_nil tr.ops_message
      assert_equal results_status.to_sym, tr.results_status
      assert_equal message, tr.message
      assert_equal [{ "name" => "OneWordWithOneVowel" }], tr.tests
      assert_equal results, tr.results

      assert submission.reload.tested
    end

    test "works with no results" do
      submission = create :submission
      ops_status = 104
      ops_message = "Some error happened"

      ProcessTestRun.(submission, ops_status, ops_message, nil)
      tr = SubmissionTestRun.last
      assert_equal submission, tr.submission
      assert_equal ops_status, tr.ops_status
      assert_equal ops_message, tr.ops_message
      assert_nil tr.results_status
      assert_nil tr.message
      assert_empty tr.tests
      assert_equal({}, tr.results)

      assert submission.reload.tested
    end

    test "works with long error message" do
      submission = create :submission
      ops_status = 200

      message = 10000.times.map{'a'}.join

      ProcessTestRun.(submission, ops_status, nil, {"message": message})
      tr = SubmissionTestRun.last
      assert_equal submission, tr.submission
      assert_equal ops_status, tr.ops_status
      assert_equal message, tr.message

      assert submission.reload.tested
    end
  end
end
