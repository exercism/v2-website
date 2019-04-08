require 'test_helper'

class ListenForAnalyzedIterationsTest < ActiveSupport::TestCase

  def test_proxies_message_correctly
    iteration_id = SecureRandom.uuid
    message = {iteration_id: iteration_id}
    propono_client = mock
    propono_client.expects(:listen).with(:iteration_analyzed).yields(message)
    Propono.expects(:configure_client).returns(propono_client)

    STDOUT.expects("puts").with(iteration_id)
    STDOUT.expects("puts").with(message)
    ListenForAnalyzedIterations.()
  end
end
