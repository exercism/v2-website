class API::Webhooks::RepoUpdatesController < API::WebhooksController
  before_action :verify_github_webhook

  MASTER_REF = "refs/heads/master"

  def create
    return unless pushed_to_master?

    repo_update = RepoUpdate.new(slug: slug)

    render json: {} if repo_update.save
  end

  private

  def payload_params
    params.require(:payload).permit(:ref, { repository: :name })
  end

  def pushed_to_master?
    payload_params[:ref].eql? MASTER_REF
  end

  def slug
    payload_params[:repository][:name]
  end

  def verify_github_webhook
    request_body = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request_body)
    if !Rack::Utils.secure_compare(signature, github_signature)
      render json: {error: 'invalid signature - delivery: %s' % github_delivery}, status: 500
    end
  end

  def secret
    Rails.application.secrets.github_webhook_secret
  end

  def github_signature
    request.env['HTTP_X_HUB_SIGNATURE']
  end

  def github_delivery
    request.headers['HTTP_X_GITHUB_DELIVERY']
  end
end
