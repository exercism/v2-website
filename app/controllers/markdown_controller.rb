class MarkdownController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def parse
    html = ParseMarkdown.(params[:markdown].to_s)
    render html: html.html_safe
  end
end
