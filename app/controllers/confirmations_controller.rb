class ConfirmationsController < Devise::ConfirmationsController
  layout :layout_from_site_context

  def create
  end

  def required
  end

  private

  def after_resending_confirmation_instructions_path_for
  end
end
