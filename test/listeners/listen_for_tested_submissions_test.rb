require 'test_helper'

class ListenForTestedSubmissionsTest < ActiveSupport::TestCase
  def test_proxies_message_correctly
    submission = create :submission
    status = mock
    results = mock
    message = {
      submission_id: submission.id,
      status: status,
      results: results
    }
    propono_client = mock
    propono_client.expects(:listen).with(:submission_tested).yields(message)
    Propono.expects(:configure_client).returns(propono_client)

    TestingServices::ProcessTestedSubmission.expects(:call).with(submission, status, results)
    ListenForTestedSubmissions.()
  end
end

