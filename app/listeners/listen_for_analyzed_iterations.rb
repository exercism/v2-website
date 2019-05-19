class ListenForAnalyzedIterations
  include Mandate

  def call
    client.listen(:iteration_analyzed) do |message|
      iteration_id = message[:iteration_id]
      status = message[:status]
      analysis = message[:analysis]

      iteration = Iteration.find_by_id(iteration_id)
      if iteration
        p "Handling iteration analysis: #{iteration_id}"
        HandleIterationAnalysis.(iteration, status, analysis)
      else
        p "No iteration: #{iteration_id}"
      end
    end
  end

  private
  def client
    @client ||= Propono.configure_client
  end
end

