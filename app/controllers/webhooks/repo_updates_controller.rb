class Webhooks::RepoUpdatesController < WebhooksController
  before_action :verify_github_webhook

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

  def verify_github_webhook
    payload = request.raw_post
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload)
    if !Rack::Utils.secure_compare(signature, github_signature)
      render json: {error: 'invalid signature - delivery: %s' % github_delivery}, status: 500
    end
  end

  def secret
    ENV['GITHUB_WEBHOOK_SECRET'] || 'hot fudge sundae' # default for test env
  end

  def github_signature
    request.env['HTTP_X_HUB_SIGNATURE']
  end

  def github_delivery
    request.headers['HTTP_X_GITHUB_DELIVERY']
  end
end
