require "test_helper"

class API::Webhooks::AnalyzersControllerTest < ActionDispatch::IntegrationTest
  test "publishes propono message if appropriate" do
    PubSub::PublishMessage.expects(:call).with(
      :analyzer_ready_to_build,
      track_slug: :ruby,
      tag: "v2.4"
    )

    post api_webhooks_analyzers_path, default_options(fixture('ruby_v2.4'))
  end

  test "does not publish for non-supported language" do
    PubSub::PublishMessage.expects(:analyzer_ready_to_build).never

    post api_webhooks_analyzers_path, default_options(fixture('foobar_v2.4'))
  end

  private

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

  def fixture(name)
    path = "#{Rails.root}/test/fixtures/analyzers/%s.json" % name
    JSON.parse(File.read(File.absolute_path(path, __FILE__)))
  end
end
