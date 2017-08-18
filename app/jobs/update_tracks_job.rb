class UpdateTracksJob < ApplicationJob
  def perform
    Git::SyncsTracks.sync
    Git::FetchesTracks.run
  end
end
