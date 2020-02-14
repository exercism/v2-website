require "test_helper"

module SubmissionTestRuns
  module Research
    class PassTest < ActionView::TestCase
      test "renders button to submit exercise" do
        test_run = create(:submission_test_run)

        render "research/submission_test_runs/pass", test_run: test_run

        assert_select "input[type=submit]", value: "Submit exercise"
      end
    end
  end
end
