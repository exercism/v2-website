module LayoutHelper
  def body_class
    classes = []
    classes << "devise" if devise_controller?
    classes << "controller-#{controller_name}"
    classes << "action-#{action_name}"
    classes.join(" ")
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
