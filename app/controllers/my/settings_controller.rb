class My::SettingsController < MyController
  def update
    if params[:user][:password].present?
      return unless update_password
    elsif params[:user][:handle].present?
      return unless update_handle
    end
    redirect_to action: :show
  end

  private

  def update_password
    if !current_user.provider? && !current_user.valid_password?(params[:old_password])
      flash.alert = "Password updated successfully"
      return true
    end

    if current_user.update(
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation]
      )
      bypass_sign_in current_user
      flash.notice = "Password updated successfully"
      return true
    else
      setup_show
      render action: :show
      return false
    end
  end

  def update_handle
    if current_user.update(handle: params[:user][:handle])
      flash.notice = "Handle updated successfully"
      return true
    else
      setup_show
      render action: :show
      return false
    end
  end
end
