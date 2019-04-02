class UnsubscribeController < ApplicationController
  before_action :load_preferences

  #http://lvh.me:3000/unsubscribe?token=c061b703-d7aa-4491-8224-8b22e1dce9f9
  def show
    @key = params[:key]
  end

  def update
    if params[:communication_preferences].present?
      @preferences.update(
        params.require(:communication_preferences).reject {|k,v|
          ['user_id', 'created_at', 'updated_at', 'token'].include?(k)
        }.permit!
      )
    end

    redirect_to({action: :show, token: @token}, notice: "Your communication Preferences have been updated successfully")
  end

  private

  def load_preferences
    @token = params[:token]
    if @token.nil?
      return redirect_to edit_my_settings_preferences_path
    end
    begin
      @preferences = CommunicationPreferences.find_by_token!(@token)
    rescue
      return redirect_to edit_my_settings_preferences_path
    end
  end
end
