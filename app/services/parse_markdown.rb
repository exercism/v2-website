class ParseMarkdown
  include Mandate
  attr_reader :text

  def initialize(text)
    @text = text.to_s
  end

  def call
    pipeline = HTML::Pipeline.new(
      [
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::SyntaxHighlightFilter
      ],
      { gfm: true, scope: "highlight" }
    )

    html = Renderer.new.render(CommonMarker.render_doc(text))
    result = pipeline.call(html)
    result[:output].to_s
  end

  class Renderer < CommonMarker::HtmlRenderer
    def link(node)
      out('<a href="', node.url.nil? ? '' : escape_href(node.url), '" target="_blank"')
      if node.title && !node.title.empty?
        out(' title="', escape_html(node.title), '"')
      end
      out('>', :children, '</a>')
    end
  end
end
