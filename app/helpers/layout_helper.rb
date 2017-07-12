module LayoutHelper
  def body_class
    classes = []
    classes << "devise" if devise_controller?
    classes << "controller-#{controller_name}"
    classes << "action-#{action_name}"
    classes.join(" ")
  end

  def notice_and_alert(object = nil)
    tags = []
    a = alert
    n = notice

    if devise_controller? && @user && @user.errors.full_messages.present?
      errors = safe_join(@user.errors.full_messages.each { |msg| msg })
      tags << content_tag(:div, errors, id: 'errors')
    end

    if object
      errors = safe_join(object.errors.full_messages.each { |msg| msg })
      tags << content_tag(:div, errors, id: 'errors')
    end

    tags << content_tag(:div, n, id: "notice") unless n.blank?
    tags << content_tag(:div, a, id: "alert") unless a.blank?
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
end
