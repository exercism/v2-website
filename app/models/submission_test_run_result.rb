class SubmissionTestRunResult
  attr_reader :test_info, :test, :status, :message

  def initialize(test_info, params)
    @test_info = test_info
    @test = params["name"]
    @status = params["status"].to_sym
    @message = params["message"]
    @output = TerminalOutput.new(params["output"])
  end

  def name
    test_info.name
  end

  def output_html
    @output_html ||= output.to_html
  end

  def passed?
    status == :pass
  end

  def failed?
    status == :fail
  end

  def cmd
    return if test_info.blank?

    test_info.cmd
  end

  def expected
    test_info.expected
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
  attr_reader :output

  def template
    test_info.msg
  end
end
