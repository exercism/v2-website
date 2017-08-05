class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_action :authenticate_user

  private
  def redirect_if_signed_in!
    redirect_to my_dashboard_path if user_signed_in?
  end

  def render_modal(class_name, template)
    html = EscapesJavascript.escape(render_to_string(template, layout: false))
    render js: %Q{ showModal('#{class_name}', "#{html}") }
  end

  def current_user_has_notifications?
    user_signed_in? && current_user.notifications.unread.exists?
  end
  helper_method :current_user_has_notifications?

  class EscapesJavascript
    extend ActionView::Helpers::JavaScriptHelper
    def self.escape(html)
      escape_javascript(html)
    end
  end
end
