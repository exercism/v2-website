require "ansi-to-html"

class TerminalOutput
  def initialize(output)
    @output = output
  end

  def to_html
    Ansi::To::Html.new(output).to_html
  end

  private
  attr_reader :output
end
