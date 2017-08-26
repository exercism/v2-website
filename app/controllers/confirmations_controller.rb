class ConfirmationsController < Devise::ConfirmationsController
  def create
    #super#
    #end
  end

  def required
  end

  private

  def after_resending_confirmation_instructions_path_for
  end
end
