class My::SettingsController < MyController
  def update
    if params[:user][:password].present?
      return unless update_password
    elsif params[:user][:handle].present?
      return unless update_handle
    elsif params[:user][:email].present?
      return unless update_email
    end
    redirect_to action: :show
  end

  def confirm_delete_account
  end

  def delete_account
    if !current_user.provider? && !current_user.valid_password?(params[:password])
      flash.alert = "Your password was incorrect"
      return redirect_to action: :confirm_delete_account
    end

    current_user.destroy
    redirect_to root_path
  end

  def reset_auth_token
    current_user.create_auth_token!
    redirect_to action: :show
  end

  def cancel_unconfirmed_email
    current_user.update(unconfirmed_email: nil)
    redirect_to action: :show
  end

  def set_default_allow_comments
    current_user.update!(default_allow_comments: params[:allow_comments])
    if params[:update_solutions]
      current_user.solutions.published.update_all(allow_comments: params[:allow_comments])
    end

    respond_to do |format|
      format.html { redirect_to my_settings_path }
      format.js { render js: "window.closeModal()" }
    end
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
      render action: :show
      return false
    end
  end

  def update_handle
    if current_user.update(handle: params[:user][:handle])
      flash.notice = "Handle updated successfully"
      return true
    else
      render action: :show
      return false
    end
  end

  def update_email
    if current_user.update(email: params[:user][:email])
      bypass_sign_in current_user
      flash.notice = "Confirmation sent to new email address"
      return true
    else
      render action: :show
      return false
    end
  end

end
