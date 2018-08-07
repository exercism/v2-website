class ConfirmationsController < Devise::ConfirmationsController
  layout :layout_from_site_context

  def required
  end

end
