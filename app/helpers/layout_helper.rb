module LayoutHelper
  def body_class
    classes = []
    classes << "devise" if devise_controller?
    classes << "controller-#{controller_name}"
    classes << "action-#{action_name}"
    classes.join(" ")
  end
end
