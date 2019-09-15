class ListenForTestedSubmissions
  include Mandate

  def call
    client.listen(:submission_tested) do |message|
      submission_id = message[:submission_id]
      status = message[:status]
      results = message[:results]

      submission = Submission.find_by_id(submission_id)
      if submission
        p "Handling submission test results: #{submission_id}"
        TestingServices::ProcessTestedSubmission.(submission, status, results)
      else
        p "No submission: #{submission_id}"
      end
    end
  end

  private
  def client
    @client ||= Propono.configure_client
  end
end


