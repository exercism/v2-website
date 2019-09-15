class SyncRepoUpdateJob < ApplicationJob
  after_perform do |job|
    repo_update = RepoUpdate.find(job.arguments.first)

    repo_update.update!(synced_at: Time.current)
  end

  def perform(repo_update_id)
    repo_update = RepoUpdate.find(repo_update_id)

    fetch_repo!(repo_update)
    sync_repo!(repo_update)
  end

  private

  def fetch_repo!(repo_update)
    Git::FetchRepo.(repo_update.repo)
  end

  def sync_repo!(repo_update)
    case repo_update.slug
    when "website-copy"
      Git::SyncWebsiteCopy.()
    when "blog"
      Git::SyncBlogPosts.()
    else
      track = Track.find_by(slug: repo_update.slug)

      Git::SyncTracks.([track]) if track
    end
  end
end
