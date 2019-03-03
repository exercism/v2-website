class My::PreferencesController < MyController
  def edit
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
    else
      redirect_to({action: :edit})
    end
  end
end
