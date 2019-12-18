require_relative './test_base'

class SPI::SubmissionTestRunControllerTest < SPI::TestBase
  test "languages" do
    expected = {
      languages: {
        ruby: {
          timeout_ms: 3000,
          container_version: "foobar123",
          num_processors: 2
        },
        javascript: {
          timeout_ms: 5000,
          container_version: "barfood987",
          num_processors: 1
        },
      }
    }

    get "/spi/test_runner/languages"
    assert_response 200
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end

  test "submissions_to_test" do
    Timecop.freeze do

      s1 = create :submission, tested: false, created_at: Time.current - 59.seconds
      s2 = create :submission, tested: false

      create :submission, tested: false, created_at: Time.current - 61.seconds
      create :submission, tested: true

      expected = {
        submissions: [
          {
            uuid: s1.uuid,
            language_slug: s1.solution.track.slug,
            exercise_slug: s1.solution.exercise.slug
          }, {
            uuid: s2.uuid,
            language_slug: s2.solution.track.slug,
            exercise_slug: s2.solution.exercise.slug
          }
        ]
      }

      get "/spi/test_runner/submissions_to_test"
      assert_response 200
      actual = JSON.parse(response.body, symbolize_names: true)
      assert_equal(expected, actual)
    end
  end

  test "submission_tested - creates submission test run on success" do
    submission = create :submission
    ops_status = 200
    results = {"foo" => "all good things"}

    SubmissionServices::ProcessTestRun.expects(:call).with(submission, ops_status, nil, results)

    post "/spi/test_runner/submission_tested/#{submission.uuid}",
      {
        ops_status: ops_status,
        results: results
      }
    assert_response 200

    expected = {received: 'ok'}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end

   test "submission_tested - creates submission test results for failure" do
    submission = create :submission
    ops_status = 200
    ops_message = "Something happened"

    SubmissionServices::ProcessTestRun.expects(:call).with(submission, ops_status, ops_message, nil)

    post "/spi/test_runner/submission_tested/#{submission.uuid}",
      {
        ops_status: ops_status,
        ops_message: ops_message,
      }
    assert_response 200

    expected = {received: 'ok'}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal(expected, actual)
  end
end
