require "open_source"

class API::Webhooks::ContributorsController < API::WebhooksController
  before_action :verify_github_webhook

  def create
    contribution = OpenSource::Contribution.new(payload_params)

    unless contribution.complete?
      head :no_content and return
    end

    contributor = Contributor.with_contribution(contribution)

    if contributor.save
      head :no_content
    else
      message = "Failed to save event with X-GitHub-Delivery: %s" % github_delivery
      render json: {error: message}, status: 500
    end
  end

  private

  def payload_params
    params.require(:payload).permit(:ref, sender: [:login, :id, :avatar_url], repository: [:default_branch])
  end

  def verify_github_webhook
    payload = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload)
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
