require 'test_helper'

class SubmissionTestRunTestTest < ActiveSupport::TestCase
  test "returns cmd" do
    solution = stub(test_messages: {
      "test_a_name_given" => {
        "cmd" => "Test.add(1, 1)"
      }
    })

    submission_test = SubmissionTestRunTest.new(
      solution,
      "name" => "test_a_name_given",
      "status" => "fail",
      "message" => "Expected: \"One for Alice, one for me.\"\n  Actual: \"One for Alice, ne for me.\""
    )

    assert_equal "Test.add(1, 1)", submission_test.cmd
  end

  test "returns message" do
    solution = stub(test_messages: {
      "test_a_name_given" => {
        "msg" => "We tried running %{output}"
      }
    })

    submission_test = SubmissionTestRunTest.new(
      solution,
      "name" => "test_a_name_given",
      "status" => "fail",
      "message" => "Failed test"
    )

    assert_equal "<p>We tried running </p><pre><code>Failed test</code></pre>\n",
      submission_test.message
  end
end
