class My::TrackSettingsController < MyController
  def edit
    setup_edit
  end

  def update
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

    if errors.empty?
      flash.notice = "Your track settings have been updated"
    elsif errors.size == 1
      flash.alert = "The handle #{errors[0]} is already taken"
    else
      flash.alert = "The handles #{errors.to_sentence} are already taken"
    end

    render action: :edit
  end

  private

  def setup_edit
    @user_tracks = current_user.user_tracks.includes(:track)
  end
end
