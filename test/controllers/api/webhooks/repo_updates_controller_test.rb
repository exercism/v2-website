require 'test_helper'

class API::Webhooks::RepoUpdatesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "create should create a RepoUpdate record when pushed to master" do
    track = create(:track, slug: "ruby")
    webhook = load_json("test/fixtures/github/push_event.json")
    webhook["ref"] = "refs/heads/master"
    webhook["repository"]["name"] = "ruby"

    post api_webhooks_repo_updates_path, default_options(webhook)

    repo_update = RepoUpdate.last
    assert_equal "ruby", repo_update.slug
  end

  test "create should not create a RepoUpdate when not pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")

    post api_webhooks_repo_updates_path, default_options(webhook)

    assert_nil RepoUpdate.last
  end

  test "create should not create a RepoUpdate when slug does not match" do
    webhook = load_json("test/fixtures/github/push_event.json")
    webhook["ref"] = "refs/heads/master"
    webhook["repository"]["name"] = "unknown"

    post api_webhooks_repo_updates_path, default_options(webhook)

    assert_nil RepoUpdate.last
  end

  test "it doesn't process a request with an invalid signature" do
    webhook = load_json("test/fixtures/github/push_event.json")
    options = default_options(webhook)
    options[:headers]['X-Hub-Signature'] = 'ZOMG wrong signature'

    post api_webhooks_repo_updates_path, options

    assert_equal 500, response.status
    assert_match "abc-123", JSON.parse(response.body)['error']
    assert_match "invalid signature", JSON.parse(response.body)['error']
  end

  private

  def load_json(file)
    JSON.parse(File.read(file))
  end

  def default_options(payload)
    body = payload.to_json
    {
      headers: {
        'Content-Type' => "application/json",
        'X-GitHub-Delivery' => 'abc-123',
        'X-Hub-Signature' => 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Rails.application.secrets.github_webhook_secret, body)
      },
      params: body
    }
  end
end
