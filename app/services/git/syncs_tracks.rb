class Git::SyncsTracks
  QUIET_PERIOD = 5.minutes

  def self.sync(tracks, stdout: STDOUT, stderr: STDERR)
    new(tracks, stdout: stdout, stderr: stderr).sync
  end

  def initialize(tracks, stdout:, stderr:)
    @tracks = tracks
    @stdout = stdout
    @stderr = stderr
  end

  def sync
    stdout.puts "Syncing tracks"
    fetch_problem_specs
    sync_tracks
    approve_hello_world_exercises
  end

  private
  attr_reader :tracks, :stdout, :stderr

  def fetch_problem_specs
    Git::ProblemSpecifications.head.fetch!
  end

  def sync_tracks
    tracks.each { |track| sync_track(track) }
  end

  def approve_hello_world_exercises
    ::Exercise.where(slug: "hello-world").update_all(auto_approve: true)
  end

  def sync_track(track)
    stdout.puts "Sync track #{track.id}"
    begin
      Git::SyncsTrack.sync!(track)
    rescue => e
      stderr.puts e.message
      stderr.puts e.backtrace
    end
  end
end
