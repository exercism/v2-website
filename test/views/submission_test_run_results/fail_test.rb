require "test_helper"

module SubmissionTestRunResults
  module Research
    class FailTest < ActionView::TestCase
      test "renders failed test with an associated command" do
        test_run = create(:submission_test_run, message: "Failed to run")

        render "research/submission_test_run_results/fail",
          test: stub(cmd: "test_true",
                     message: "Asserted to be true",
                     output_html: nil),
          test_idx: 1

        assert_select "code", "test_true"
        assert_select "pre", text: "Asserted to be true"
      end

      test "renders failed test with an associated template" do
        skip # TODO: TEST RUN

        render "research/submission_test_run_results/fail",
          test: stub(
            cmd: nil,
            text: "This is the failed test <pre>Asserted to be true</pre>",
            output_html: nil
          ),
          test_idx: 1

        assert_select "p", "This is the failed test"
        assert_select "pre", text: "Asserted to be true"
      end

      test "renders failed test without a command or message" do
        skip # TODO: TEST RUN

        test_run = create(:submission_test_run, message: "Failed to run")

        render "research/submission_test_run_results/fail",
          test: stub(
            cmd: nil,
            text: nil,
            message: "Asserted to be true",
            output_html: nil
          ),
          test_idx: 1

        assert_select "pre", text: "Asserted to be true"
      end
    end
  end
end
