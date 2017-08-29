class SyncRepoUpdateJob < ApplicationJob
  after_perform do |job|
    repo_update = RepoUpdate.find(job.arguments.first)

    repo_update.update!(synced_at: Time.current)
  end

  def perform(repo_update_id)
    repo_update = RepoUpdate.find(repo_update_id)
    track = Track.find_by(slug: repo_update.slug)

    Git::SyncsTracks.sync([track]) if track
  end
end
