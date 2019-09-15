class API::Webhooks::AnalyzersController < API::WebhooksController
  before_action :verify_github_webhook

  def create
    repo = params[:repository][:name]
    track_slug = repo.gsub(/-analyzer$/, '').to_sym

    return unless Exercism::ANALYZERS.include?(track_slug)

    tag = params[:release][:tag_name]

    PubSub::PublishMessage.(:analyzer_ready_to_build, {
      track_slug: track_slug,
      tag: tag,
    })

    head :ok
  end
end
