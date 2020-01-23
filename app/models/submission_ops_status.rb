class SubmissionOpsStatus
  extend ActiveModel::Translation

  attr_reader :test_run
  def initialize(test_run)
    @test_run = test_run
  end

  def as_json(*args)
    status
  end

  def status
    return :queued if test_run.nil?

    if code == 200
      test_run.pass? ? :pass : :fail
    else
      :error
    end
  end

  def to_partial_path
    "research/submission_ops_status/#{status}"
  end

  def code
    return if test_run.nil?

    test_run.ops_status
  end
end
