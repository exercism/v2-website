class SubmissionTestRunResult
  attr_reader :tests_info, :name, :status, :output

  def initialize(tests_info, params)
    @tests_info = tests_info
    @name = params["name"]
    @status = params["status"]
    @output = params["message"]
  end

  def failed?
    status == "fail"
  end

  def cmd
    return if test_message.blank?

    test_message.cmd
  end

  def message
    return if test_message.blank?

    ParseMarkdown.(
      template.gsub("%{output}", "<pre><code>#{output}</code></pre>")
    )
  end

  def to_partial_path
    "research/submission_test_run_results/#{status}"
  end

  private

  def test_message
    tests_info.find { |message| message.name == name }
  end

  def template
    test_message.msg
  end
end
