class PauseUserTrack
  include Mandate

  initialize_with :user_track

  def call
    ActiveRecord::Base.transaction do
      user_track.update(paused_at: Time.current)
      user_track.solutions.update_all(paused: true)
    end
  end
end
