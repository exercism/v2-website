class SubmissionTestRunResult
  attr_reader :test_info, :name, :status, :message, :output

  def initialize(test_info, params)
    @test_info = test_info
    @name = params["name"]
    @status = params["status"]
    @message = params["message"]
    @output = params["output"]
  end

  def failed?
    status == "fail"
  end

  def cmd
    return if test_info.blank?

    test_info.cmd
  end

  def text
    return if test_info.blank?

    ParseMarkdown.(
      template.gsub("%{output}", "<pre><code>#{message}</code></pre>")
    )
  end

  def to_partial_path
    "research/submission_test_run_results/#{status}"
  end

  private

  def template
    test_info.msg
  end
end
