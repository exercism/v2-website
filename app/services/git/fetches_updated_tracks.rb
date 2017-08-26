class Git::FetchesUpdatedTracks

  QUIET_PERIOD = 30.seconds

  def self.run
    new.run
  end

  def self.fetch
    new.fetch
  end

  def run
    loop do
      fetch
      sleep QUIET_PERIOD
    end
  end

  def fetch
    find_track_update
    fetch_track_update if track_update
  end

  private

  attr_reader :track_update, :track_update_fetch

  def find_track_update
    @track_update = track_updates_without_fetches || track_updates_not_fetched
  end

  def track_updates_without_fetches
    TrackUpdate.
      includes(:track_update_fetches).
      where(synced_at: nil).
      find_by(track_update_fetches: { track_update_id: nil })
  end

  def track_updates_not_fetched
    TrackUpdate.
      includes(:track_update_fetches).
      where(synced_at: nil).
      where.not(track_update_fetches: { host: Socket.gethostname }).
      first
  end

  def fetch_track_update
    FetchTrackUpdateJob.perform_later(track_update.id)
  end
end
