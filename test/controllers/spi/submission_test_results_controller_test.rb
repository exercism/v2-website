require_relative './test_base'

class SPI::SubmissionTestResultsControllerTest < SPI::TestBase
   test "creates submission test results for success" do
    submission = create :submission
    ops_status = 200
    results = {"foo" => "all good things"}

    SubmissionServices::ProcessTestResults.expects(:call).with(submission, ops_status, nil, results)

    post spi_submission_test_results_path(
        submission_uuid: submission.uuid,
      ), {
        ops_status: ops_status,
        results: results
      }
    assert_response 200

    expected = {received: 'ok'}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end

   test "creates submission test results for failure" do
    submission = create :submission
    ops_status = 200
    ops_message = "Something happened"

    SubmissionServices::ProcessTestResults.expects(:call).with(submission, ops_status, ops_message, nil)

    post spi_submission_test_results_path(
        submission_uuid: submission.uuid,
      ), {
        ops_status: ops_status,
        ops_message: ops_message,
      }
    assert_response 200

    expected = {received: 'ok'}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end
end
