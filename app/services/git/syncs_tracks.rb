class Git::SyncsTracks

  QUIET_PERIOD = 10.seconds
  MIN_FETCH_PERIOD = 15.minutes
  MIN_FAIL_WAIT_PERIOD = 5.minutes

  def self.sync
    new.sync
  end

  def sync
    loop do
      puts "Syncing outstanding tracks"
      sync_outstanding
      puts "Sleeping"
      sleep QUIET_PERIOD
    end
  end

  private

  def sync_outstanding
    loop do
      track = next_to_sync
      puts "Next track to sync: #{track.to_s}"
      break if track.nil?
      sync_one(track)
    end
  end

  def sync_one(track)
    puts "Sync track #{track.id}"
    begin
      Git::SyncsTrack.sync!(track)
    rescue => e
      puts e.message
      puts e.backtrace
      track.update!(git_failed_at: DateTime.now)
    end
  end

  def next_to_sync
    next_requested || next_stale
  end

  def next_requested
    selector.where(git_sync_required: true).first
  end

  def next_stale
    selector.where('git_synced_at < ?', MIN_FETCH_PERIOD.ago).first
  end

  def selector
    Track.where('git_failed_at IS NULL or git_failed_at < ?', MIN_FAIL_WAIT_PERIOD.ago).order('updated_at DESC')
  end

end
