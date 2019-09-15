class Mentor::ConfigureController < MentorController
  def show
    @mentored_track_ids = current_user.mentored_tracks.pluck(:id)
  end

  def update
    selected_tracks = Set.new((params["track_id"].presence || {}).keys)

    mentored_track_ids = Set.new(current_user.mentored_tracks.pluck(:id).map(&:to_s))

    tracks_to_create = selected_tracks - mentored_track_ids
    tracks_to_remove = mentored_track_ids - selected_tracks

    TrackMentorship.transaction do
      tracks_to_create.each do |track_id|
        begin
          TrackMentorship.create!(user: current_user, track_id: track_id)
        rescue ActiveRecord::RecordNotUnique
        end
      end
      TrackMentorship.where(user: current_user, track_id: tracks_to_remove).destroy_all
    end

    if TrackMentorship.where(user_id: current_user.id).exists?
      redirect_to mentor_dashboard_path
    else
      redirect_to({action: :show}, alert: "No tracks were chosen")
    end
  end
end
