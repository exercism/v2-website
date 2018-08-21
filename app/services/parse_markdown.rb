class ParseMarkdown
  include Mandate
  attr_reader :text

  def initialize(text)
    @text = text.to_s
  end

  def call
    pipeline = HTML::Pipeline.new(
      [
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::SyntaxHighlightFilter
      ],
      { gfm: true, scope: "highlight" }
    )

    result = pipeline.call(text)
    result[:output].to_s
  end
end
