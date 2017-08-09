class My::CommunicationPreferencesController < MyController
  def edit
  end

  def update
    current_user.communication_preferences.update(
      params.require(:communication_preferences).reject {|k,v|
        ['user_id', 'created_at', 'updated_at'].include?(k)
      }.permit!
    )
    redirect_to({action: :edit}, notice: "Communication preferences updated successfully")
  end
end
