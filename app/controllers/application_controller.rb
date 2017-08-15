class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :store_location

  private

  # This saves the current user location for devise
  def store_location
    return if user_signed_in?
    return if devise_controller?
    return if request.xhr?
    return unless request.get?

    session["user_return_to"] = request.fullpath
  end

  def redirect_if_signed_in!
    redirect_to my_dashboard_path if user_signed_in?
  end

  def render_modal(class_name, template)
    html = EscapesJavascript.escape(render_to_string(template, layout: false))
    render js: %Q{ showModal('#{class_name}', "#{html}") }
  end

  def js_redirect_to(*objs)
    render js: %Q{ window.location = "#{url_for(objs)}"}
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
