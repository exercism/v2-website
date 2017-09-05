class Webhooks::RepoUpdatesController < WebhooksController
  MASTER_REF = "refs/heads/master"

  def create
    return unless pushed_to_master?

    repo_update = RepoUpdate.new(slug: slug)

    render json: {} if repo_update.save
  end

  private

  def pushed_to_master?
    params[:ref].eql? MASTER_REF
  end

  def slug
    params.fetch(:repository).fetch(:name)
  end
end
