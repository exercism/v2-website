class Git::SyncsTracks
  QUIET_PERIOD = 5.minutes

  def self.sync(tracks)
    new(tracks).sync
  end

  def initialize(tracks)
    @tracks = tracks
  end

  def sync
    puts "Syncing tracks"
    tracks.each { |track| sync_track(track) }
    ::Exercise.where(slug: "hello-world").update_all(auto_approve: true)
  end

  private
  attr_reader :tracks

  def sync_track(track)
    puts "Sync track #{track.id}"
    begin
      Git::SyncsTrack.sync!(track)
    rescue => e
      puts e.message
      puts e.backtrace
    end
  end
end
