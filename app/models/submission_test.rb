class SubmissionTest
  attr_reader :name, :status, :message
  def initialize(params)
    @name = params["name"]
    @status = params["status"]
    @message = params["message"]
  end

  def failed?
    status == "fail"
  end
end
