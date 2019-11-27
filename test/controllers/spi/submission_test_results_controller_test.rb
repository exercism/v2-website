require_relative './test_base'

class SPI::SubmissionTestResultsControllerTest < SPI::TestBase
   test "creates submission test results" do
    submission = create :submission
    status = "good"
    results = {"foo" => "all good things"}

    SubmissionServices::ProcessTestResults.expects(:call).with(submission, status, results)

    post spi_submission_test_results_path(
        submission_uuid: submission.uuid,
      ), {
        status: status,
        results: results.to_json
      }
    assert_response 200

    expected = {received: 'ok'}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end
end
