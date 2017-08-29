class Webhooks::RepoUpdatesController < WebhooksController
  MASTER_REF = "refs/heads/master"

  def create
    RepoUpdate.create(slug: slug) if pushed_to_master?

    render json: {}, status: 200
  end

  private

  def pushed_to_master?
    params[:ref].eql? MASTER_REF
  end

  def slug
    params.fetch(:repository).fetch(:name)
  end
end
