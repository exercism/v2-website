module HtmlGenerationHelpers
  def strong(text)
    "<strong>#{text}</strong>"
  end

  def routes
    Rails.application.routes.url_helpers
  end
end
