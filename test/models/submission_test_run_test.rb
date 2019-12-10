require 'test_helper'

class SubmissionTestRunTest < ActiveSupport::TestCase
  test "#tests_to_display retruns tests based on test info order" do
    order = ReverseOrder.new
    test_run = create(:submission_test_run,
                      tests: [
                        {
                          "name" => "OneWordWithTwoVowels",
                          "status" => "pass",
                        },
                        {
                          "name" => "OneWordWithOneVowel",
                          "status" => "pass",
                        }
                      ])

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_run.tests_to_display(order).map(&:name)
    )
  end

  test "#tests_to_display retruns tests until the first failed test" do
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
                      ])

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithTwoVowels"],
      test_run.tests_to_display.map(&:name)
    )
  end

  class ReverseOrder
    def reorder(tests)
      tests.reverse
    end
  end
end
