require_relative './test_base'

class SPI::SubmissionTestResultsControllerTest < SPI::TestBase
   test "creates submission test results" do
    submission = create :submission
    ops_status = 200
    ops_message = "Something happened"
    results = {"foo" => "all good things"}

    SubmissionServices::ProcessTestResults.expects(:call).with(submission, ops_status, results)

    post spi_submission_test_results_path(
        submission_uuid: submission.uuid,
      ), {
        ops_status: ops_status,
        ops_message: ops_message,
        results: results
      }
    assert_response 200

    s = Submission.last
    assert_equal ops_status, s.ops_status
    assert_equal ops_message, s.ops_message
    assert_equal results, s.results

    expected = {received: 'ok'}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end
end
