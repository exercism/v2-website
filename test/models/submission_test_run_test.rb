require 'test_helper'

class SubmissionTestRunTest < ActiveSupport::TestCase
  test "#tests retruns tests based on test info order" do
    solution = create(:research_experiment_solution)
    submission = create(:submission, solution: solution)
    test_run = create(:submission_test_run,
                      tests: [
                        {
                          "name" => "OneWordWithTwoVowels",
                          "status" => "fail",
                        },
                        {
                          "name" => "OneWordWithOneVowel",
                          "status" => "fail",
                        }
                      ],
                      submission: submission)

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_run.tests.map(&:name)
    )
  end

  test "#tests_to_display retruns tests until the first failed test" do
    solution = create(:research_experiment_solution)
    submission = create(:submission, solution: solution)
    test_run = create(:submission_test_run,
                      tests: [
                        {
                          "name" => "OneWordWithOneVowel",
                          "status" => "pass",
                        },
                        {
                          "name" => "OneWordWithTwoVowels",
                          "status" => "fail",
                        },
                      ],
                      submission: submission)

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_run.tests_to_display.map(&:name)
    )
  end
end
