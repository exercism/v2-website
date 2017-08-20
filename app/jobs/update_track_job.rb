class UpdateTrackJob < ApplicationJob
  def perform(track)
    Git::FetchesTrack.fetch(track)
    Git::SyncsTrack.sync!(track)
  end
end
