class ListenForAnalyzedIterations
  include Mandate

  def call
    client.listen(:iteration_analyzed) do |message|
      puts message[:iteration_id]
      puts message
    end
  end

  private
  def client
    @client ||= Propono.configure_client
  end
end

