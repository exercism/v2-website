module LayoutHelper
  def body_class
    classes = []
    classes << "devise" if devise_controller?
    classes << "namespace-#{namespace_name}"
    classes << "controller-#{controller_name}"
    classes << "action-#{action_name}"
    classes << "prism-dark" if user_signed_in? && current_user.dark_code_theme
    classes << (user_signed_in?? "user-signed_in" : "user-signed_out")
    classes.join(" ")
  end

  def namespace_name
    @namespace_name ||= begin
      controller_parts = controller.class.name.underscore.split("/")
      controller_parts.size > 1 ? controller_parts[0] : 'none'
    end
  end

  def clear_flash
    flash.clear
  end

  def notice_and_alert(object = nil, html_messages: false)
    tags = []
    a = alert
    n = notice

    if devise_controller? && @user && @user.errors.full_messages.present?
      errors = if html_messages
          @user.errors.full_messages.join("<br/>").html_safe
        else
          safe_join(@user.errors.full_messages.each { |msg| msg }, "<br/>".html_safe)
        end
      tags << content_tag(:div, errors, id: 'errors')
    end

    if object && object.errors.full_messages.present?
      errors = safe_join(object.errors.full_messages.each { |msg| msg }, "<br/>".html_safe)
      tags << content_tag(:div, errors, id: 'errors')
    end

    tags << content_tag(:div, n, id: "notice") unless n.blank?
    tags << content_tag(:div, (html_messages ? raw(a) : a), id: "alert") unless a.blank?

    safe_join(tags)
  end

  # Clear the flash by calling these methods
  def clear_notice_and_alert
  end

  def render_header
    if devise_controller?
      render "layouts/logged_out_header"
    elsif user_signed_in?
      render "layouts/logged_in_header"
    else
      render "layouts/logged_out_header"
    end
  end

  def render_teams_header
    if devise_controller?
      render "layouts/logged_out_teams_header"
    elsif user_signed_in?
      render "layouts/logged_in_teams_header"
    else
      render "layouts/logged_out_teams_header"
    end
  end

  def render_cta_footer
    render "layouts/cta_footer"
  end
end
