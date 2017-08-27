class My::SettingsController < MyController
  def show
    setup_show
  end

  def update_user_tracks
    @user_tracks = current_user.user_tracks.includes(:track)
    mapped_user_tracks = @user_tracks.each_with_object({}) {|ut, h|h[ut.id] = ut }

    errors = []
    params[:user_tracks].each do |id, data|
      anon = data[:anonymous].to_i == 1
      handle = data[:handle].present?? data[:handle] : nil

      success = mapped_user_tracks[id.to_i].update(
        anonymous: anon, handle: handle
      )
      errors << handle if !success && anon
    end

    errors.uniq!

    if errors.size == 0
      flash.notice = "Your track settings have been updated"
    elsif errors.size == 1
      flash.alert = "The handle #{errors[0]} is already taken"
    else
      flash.alert = "The handles #{errors.to_sentence} are already taken"
    end

    render action: :show
  end

  def update
    if params[:user][:password].present?
      if current_user.provider? || current_user.valid_password?(params[:old_password])
        if current_user.update(
            password: params[:user][:password],
            password_confirmation: params[:user][:password_confirmation]
          )
          sign_in(current_user, bypass: true)
          flash.notice = "Password updated successfully"
        else
          setup_show
          return render action: :show
        end
      else
        flash.alert = "Password updated successfully"
      end
    end
    redirect_to action: :show
  end

  private

  def setup_show
    @user_tracks = current_user.user_tracks.includes(:track)
  end
end
