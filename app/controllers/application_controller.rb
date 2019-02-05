class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :store_location
  before_action :set_site_context

  private

  # This saves the current user location for devise
  def store_location
    return if devise_controller?
    return if user_signed_in?
    return if request.xhr?
    return unless request.get?

    session["return_to"] = request.fullpath
  end

  def after_sign_in_path_for(resource)
    session["return_to"] || signed_in_path
  end

  def set_site_context
    return unless request.get?
    return if devise_controller?

    cookies["site_context"] = {
      value: "normal",
      domain: :all,
      tld_length: 2
    }
  end

  def layout_from_site_context
    case cookies["site_context"]
    when "teams"
      "teams"
    else
      "application"
    end
  end

  def redirect_if_signed_in!
    redirect_to signed_in_path if user_signed_in?
  end

  def render_modal(class_name, template, options = {})
    html = EscapesJavascript.escape(render_to_string(template, layout: false))
    render js: %Q{
      showModal('#{class_name}', '#{html}', '#{options.to_json}')
      Prism.highlightAll()
    }
  end

  def js_redirect_to(*objs)
    render js: %Q{ window.location = "#{url_for(*objs)}"}
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

  def signed_in_path
    if cookies["site_context"] == "teams"
      teams_dashboard_path
    else
      my_dashboard_path
    end
  end

  def render_404
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end
end
