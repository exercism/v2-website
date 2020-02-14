require "test_helper"

module SubmissionTestRunResults
  module Research
    class FailTest < ActionView::TestCase
      test "renders failed test with an associated command" do
        test_run = create(:submission_test_run, message: "Failed to run")

        render "research/submission_test_run_results/fail",
          test: stub(cmd: "test_true",
                     message: "Asserted to be true",
                     name: "Test 1",
                     output_html: nil)

        assert_select "code", "test_true"
        assert_select "pre", text: "Asserted to be true"
      end
    end
  end
end
