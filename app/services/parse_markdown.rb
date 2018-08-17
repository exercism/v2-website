require 'commonmarker'

class ParseMarkdown
  include Mandate

  attr_reader :text
  def initialize(text)
    @text = text.to_s
  end

  def call
    sanitized_html
  end

  private

  def sanitized_html
    @sanitized_html ||= Loofah.fragment(raw_html).scrub!(:escape).to_s
  end

  def raw_html
    @raw_html ||= Renderer.new.render(CommonMarker.render_doc(preprocessed_text))
  end

  def preprocessed_text
    @preprocessed_text ||=
      text.gsub(/^`{3,}(.*?)`{3,}\s*$/m) { "\n#{$&}\n" }
  end

  class Renderer < CommonMarker::HtmlRenderer
    def link(node)
      out('<a href="', node.url.nil? ? '' : escape_href(node.url), '" target="_blank"')
      if node.title && !node.title.empty?
        out(' title="', escape_html(node.title), '"')
      end
      out('>', :children, '</a>')
    end

    def code_block(node)
      block do
        out("<pre#{sourcepos(node)}><code")
        if node.fence_info && !node.fence_info.empty?
          out(' class="language-', node.fence_info.split(/\s+/)[0], '">')
        else
          out(' class="language-plain">')
        end
        out(escape_html(node.string_content))
        out('</code></pre>')
      end
    end
  end
end
