class BootstrapUser
  include Mandate

  attr_reader :user, :initial_track_id
  def initialize(user, initial_track_id = nil)
    @user = user
    @initial_track_id = initial_track_id
  end

  def call
    user.auth_tokens.create!(token: SecureRandom.uuid)

    if initial_track_id
      track = Track.find_by_id(initial_track_id)
      JoinTrack.(user, track) if track
    end
  end
end
