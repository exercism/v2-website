class My::PreferencesController < MyController
  def edit
  end

  def update_theme
    current_user.update!(theme: params[:theme])
    head 200
  end

  def update
    if params[:communication_preferences].present?
      current_user.communication_preferences.update(
        params.require(:communication_preferences).reject {|k,v|
          ['user_id', 'created_at', 'updated_at', 'token'].include?(k)
        }.permit!
      )
      redirect_to({action: :edit}, notice: "Your communication Preferences have been updated successfully")
    elsif params[:update_dark_theme].present?
      current_user.update(dark_code_theme: (params[:dark_code_theme] == "1"))
      redirect_to({action: :edit}, notice: "Code theme preference updated successfully")
    elsif params[:update_require_password_to_update_communication_preferences].present?
      if params[:require_password_to_update_communication_preferences] == "1"
        current_user.communication_preferences.update(token: nil)
      else
        current_user.communication_preferences.update(token: SecureRandom.uuid)
      end
      redirect_to({action: :edit}, notice: "Password preference updated successfully")
    elsif update_code_viewing_preferences?
      current_user.update!(code_viewing_preference_params)

      redirect_to(
        {action: :edit},
        notice: "Code viewing preference updated successfully"
      )
    else
      redirect_to({action: :edit})
    end
  end

  private

  def update_code_viewing_preferences?
    params[:user][:update_code_viewing_options].present?
  end

  def code_viewing_preference_params
    params.require(:user).permit(:full_width_code_panes)
  end
end
