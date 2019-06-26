require 'test_helper'

class ListenForAnalyzedIterationsTest < ActiveSupport::TestCase

  def test_proxies_message_correctly
    iteration = create :iteration
    status = mock
    analysis = mock
    message = {
      iteration_id: iteration.id,
      status: status,
      analysis: analysis
    }
    propono_client = mock
    propono_client.expects(:listen).with(:iteration_analyzed).yields(message)
    Propono.expects(:configure_client).returns(propono_client)

    AnalysisServices::ProcessAnalysis.expects(:call).with(iteration, status, analysis)
    ListenForAnalyzedIterations.()
  end
end
