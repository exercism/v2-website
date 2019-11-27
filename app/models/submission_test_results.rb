class SubmissionTestResults < ApplicationRecord
  belongs_to :submission

  def results_status
    super.try(&:to_sym)
  end

  def pass?
    results_status == :pass
  end

  def errored?
    results_status == :error
  end

  def failed?
    results_status == :fail
  end

  def tests
    super.map { |test| SubmissionTest.new(test) }
  end

  def failed_tests
    tests.select(&:failed?)
  end

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
end
