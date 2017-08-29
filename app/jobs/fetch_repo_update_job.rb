class FetchRepoUpdateJob < ApplicationJob
  attr_accessor :repo_update_fetch_id

  before_perform do |job|
    repo_update = RepoUpdate.find(job.arguments.first)

    repo_update_fetch = RepoUpdateFetch.create!(
      repo_update: repo_update,
      host: Socket.gethostname
    )

    job.repo_update_fetch_id = repo_update_fetch.id
  end

  after_perform do |job|
    repo_update_fetch = RepoUpdateFetch.find(job.repo_update_fetch_id)

    repo_update_fetch.update!(completed_at: Time.current)
  end

  def perform(repo_update_id)
    repo_update = RepoUpdate.find(repo_update_id)

    Git::FetchesRepos.fetch([repo_update.repo])
  end
end
