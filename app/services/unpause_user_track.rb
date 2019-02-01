class UnpauseUserTrack
  include Mandate

  initialize_with :user_track

  def call
    ActiveRecord::Base.transaction do
      user_track.update(paused_at: nil)
      user_track.solutions.update_all(paused: false)
    end
  end
end
