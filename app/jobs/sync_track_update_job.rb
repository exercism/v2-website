class SyncTrackUpdateJob < ApplicationJob
  after_perform do |job|
    track_update = TrackUpdate.find(job.arguments.first)

    track_update.update!(synced_at: Time.current)
  end

  def perform(track_update_id)
    track_update = TrackUpdate.find(track_update_id)

    Git::SyncsTracks.sync([track_update.track])
  end
end
