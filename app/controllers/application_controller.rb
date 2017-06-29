class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private
  def render_modal(class_name, template)
    html = EscapesJavascript.escape(render_to_string(template, layout: false))
    render js: %Q{ showModal('#{class_name}', "#{html}") }
  end

  class EscapesJavascript
    extend ActionView::Helpers::JavaScriptHelper
    def self.escape(html)
      escape_javascript(html)
    end
  end
end
