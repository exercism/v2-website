class Git::SyncsUpdatedTracks
  QUIET_PERIOD = 10.seconds

  def self.run
    new.run
  end

  def self.sync
    new.sync
  end

  def run
    loop do
      sync
      puts "Sleeping"
      sleep QUIET_PERIOD
    end
  end

  def sync
    find_track_update
    if track_update
      puts "Syncing outstanding tracks"
      sync_track_update
    end
  end

  private
  attr_reader :track_update

  def find_track_update
    @track_update = TrackUpdate.
      joins(:track_update_fetches).
      where(synced_at: nil).
      where.not(track_update_fetches: { completed_at: nil }).
      group("track_update_fetches.id").
      having("count(track_update_id) = #{ClusterConfig.num_webservers}").
      first
  end

  def sync_track_update
    SyncTrackUpdateJob.perform_later(track_update)
  end
end
