require "test_helper"

module SubmissionTestRuns
  module Research
    class ErrorTest < ActionView::TestCase
      test "renders error message" do
        test_run = create(:submission_test_run, message: "Failed to run")

        render "research/submission_test_runs/error", test_run: test_run

        assert_select "pre", text: "Failed to run"
      end
    end
  end
end
