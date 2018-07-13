class Mentor::ConfigureController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    if params["track_id"].present?
      track_ids = params["track_id"].keys
      TrackMentorship.transaction do
        track_ids.each do |track_id|
          begin
            TrackMentorship.create!(user: current_user, track_id: track_id)
          rescue ActiveRecord::RecordNotUnique
          end
        end
      end
    end

    if TrackMentorship.where(user_id: current_user.id).exists?
      redirect_to mentor_dashboard_path
    else
      redirect_to({action: :show}, alert: "No tracks were chosen")
    end
  end
end
