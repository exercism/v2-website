require 'lmdb'

class Git::StateDb

  DB_LOCATION="#{Rails.root}/tmp/git_state_db"
  MIN_FETCH_PERIOD = 5.minutes
  MIN_FAIL_WAIT_PERIOD = 2.minutes

  def self.instance
    @@db ||= new(DB_LOCATION, MIN_FAIL_WAIT_PERIOD)
  end

  attr_reader :lmdb, :failure_cooloff_period

  def initialize(db_location, failure_cooloff_period)
    FileUtils.mkdir_p(db_location)
    @lmdb = LMDB.new(db_location)
    @failure_cooloff_period = failure_cooloff_period
    ObjectSpace.define_finalizer( self, Proc.new { @lmdb.close } )
  end

  def mark_synced(track)
    set(track, { last_sync: Time.current, success: true, track_id: track.id } )
  end

  def mark_failed(track)
    set(track, { last_sync: Time.current, success: false, track_id: track.id } )
  end

  def reset(track)
    set(track, { last_sync: nil, success: nil, track_id: track.id } )
  end

  def sync_state_for(track)
    state = get(track)
    if state.nil?
      { last_sync: nil, success: nil, track_id: track.id }
    else
      state
    end
  end

  def stale_tracks_before(min_fetch_period=MIN_FETCH_PERIOD)
    stale_cut_off = Time.current - min_fetch_period
    failure_cut_off = Time.current - failure_cooloff_period
    failures_to_retry = []
    to_sync = []
    lmdb.transaction do |txn|
      primary_db.cursor do |cursor|
        item = cursor.first
        until item.nil?
          state = rehydrate_record(item[1])
          if state[:success].nil?
            to_sync << state
          elsif state[:success]
            to_sync << state if state[:last_sync] < stale_cut_off
          else
            failures_to_retry << state if state[:last_sync] < failure_cut_off
          end
          item = cursor.next
        end
      end
      txn.abort
    end
    ff = failures_to_retry.sort_by { |s| s[:last_sync] || DateTime.new(0) }.reverse
    ss = to_sync.sort_by { |s| s[:last_sync] || DateTime.new(0) }.reverse
    ss + ff
  rescue LMDB::Error::NOTFOUND => e
    puts e.message
    []
  end

  def delete_id(track_id)
    primary_db.delete(key_for_id(track_id))
  end

  private

  def get(track)
    val = primary_db[key_for(track)]
    return nil if val.nil?
    rehydrate_record(val)
  end

  def rehydrate_record(val)
    return nil if val.nil?
    entry = JSON.parse(val, symbolize_names: true)
    entry[:last_sync] = DateTime.parse(entry[:last_sync]) unless entry[:last_sync].nil?
    entry
  end

  def set(track, state)
    primary_db[key_for(track)] = state.to_json
  end

  def primary_db
    lmdb.database
  end

  def key_for(track)
    key_for_id(track.id)
  end

  def key_for_id(track_id)
    "track-#{track_id}"
  end

end
