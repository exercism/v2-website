require 'test_helper'

class SubmissionTestRunTest < ActiveSupport::TestCase
  test "#tests_to_display retruns all passed tests and the first failed test" do
    order = NormalOrder.new
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
                        {
                          "name" => "OneWordWithThreeVowels",
                          "status" => "pass",
                        },
                        {
                          "name" => "OneWordWithFourVowels",
                          "status" => "fail",
                        },
                      ])

    assert_equal(
      ["OneWordWithOneVowel", "OneWordWithThreeVowels", "OneWordWithTwoVowels"],
      test_run.tests_to_display(order).map(&:test)
    )
  end

  class NormalOrder
    def reorder(tests)
      tests
    end
  end
end
