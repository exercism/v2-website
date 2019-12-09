require "test_helper"

module SubmissionTestRuns
  module Research
    class FailTest < ActionView::TestCase
      test "renders failed test with an associated command" do
        test_run = create(:submission_test_run, message: "Failed to run")
        test_run.stubs(:failed_tests).returns([
          stub(cmd: "test_true", output: "Asserted to be true")
        ])

        render "research/submission_test_runs/fail",
          test_run: test_run

        assert_select "code", "test_true"
        assert_select "pre", text: "Asserted to be true"
      end

      test "renders failed test with an associated template" do
        test_run = create(:submission_test_run, message: "Failed to run")
        test_run.stubs(:failed_tests).returns([
          stub(cmd: nil,
               message: "This is the failed test <pre>Asserted to be true</pre>")
        ])

        render "research/submission_test_runs/fail",
          test_run: test_run

        assert_select "p", "This is the failed test"
        assert_select "pre", text: "Asserted to be true"
      end

      test "renders failed test without a command or message" do
        test_run = create(:submission_test_run, message: "Failed to run")
        test_run.stubs(:failed_tests).returns([
          stub(cmd: nil, message: nil, output: "Asserted to be true")
        ])

        render "research/submission_test_runs/fail", test_run: test_run

        assert_select "pre", text: "Asserted to be true"
      end
    end
  end
end
