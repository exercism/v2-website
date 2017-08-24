class FetchTrackUpdateJob < ApplicationJob
  attr_accessor :track_update_fetch_id

  before_perform do |job|
    track_update = TrackUpdate.find(job.arguments.first)

    track_update_fetch = TrackUpdateFetch.create!(
      track_update: track_update,
      host: Socket.gethostname
    )

    job.track_update_fetch_id = track_update_fetch.id
  end

  after_perform do |job|
    track_update_fetch = TrackUpdateFetch.find(job.track_update_fetch_id)

    track_update_fetch.update!(completed_at: Time.current)
  end

  def perform(track_update_id)
    track_update = TrackUpdate.find(track_update_id)

    Git::FetchesTracks.fetch([track_update.track])
  end
end
