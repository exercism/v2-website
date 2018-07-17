require "test_helper"

class API::Webhooks::ContributorsControllerTest < ActionDispatch::IntegrationTest
  test "does not save incomplete contributions" do
    post api_webhooks_contributors_path, default_options(fixture('pull_request_event.closed'))

    assert_equal 0, Contributor.count
  end

  test "saves a contribution" do
    post api_webhooks_contributors_path, default_options(fixture('pull_request_event.merged.to_default_master'))

    assert_equal 1, Contributor.count
  end

  test "provides a useful error message if record fails to save" do
    payload = fixture('pull_request_event.merged.to_default_master')
    payload['pull_request']['user']['login'] = nil
    post api_webhooks_contributors_path, default_options(payload)

    assert_equal 500, response.status
    assert_match "abc-123", JSON.parse(response.body)['error']
  end

  test "it doesn't process a request with an invalid signature" do
    payload = fixture('pull_request_event.merged.to_non_default_branch')

    options = default_options(payload)
    options[:headers]['X-Hub-Signature'] = 'ZOMG wrong signature'
    post api_webhooks_contributors_path, options

    assert_equal 500, response.status
    assert_match "abc-123", JSON.parse(response.body)['error']
    assert_match "invalid signature", JSON.parse(response.body)['error']
  end

  private

  def default_options(payload)
    body = { payload: payload }.to_json
    {
      headers: {
        'Content-Type' => "application/json",
        'X-GitHub-Delivery' => 'abc-123',
        'X-Hub-Signature' => 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Rails.application.secrets.github_webhook_secret, body)
      },
      params: body
    }
  end

  def fixture(name)
    path = "#{Rails.root}/test/fixtures/contributions/%s.json" % name
    JSON.parse(File.read(File.absolute_path(path, __FILE__)))
  end
end
