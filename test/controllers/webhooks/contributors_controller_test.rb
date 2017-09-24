require_relative '../../test_helper'

class Webhooks::ContributorsControllerTest < ActionDispatch::IntegrationTest
  test "does not save incomplete contributions" do
    post webhooks_contributors_path, default_options(fixture('pull_request_event.closed'))

    assert_equal 0, Contributor.count
  end

  test "saves a contribution" do
    post webhooks_contributors_path, default_options(fixture('pull_request_event.merged.to_default_master'))

    assert_equal 1, Contributor.count
  end

  test "provides a useful error message if record fails to save" do
    payload = fixture('pull_request_event.merged.to_default_master')
    payload['pull_request']['user']['login'] = nil
    post webhooks_contributors_path, default_options(payload)

    assert_equal 500, response.status
    assert_match "abc-123", JSON.parse(response.body)['error']
  end

  test "it doesn't process a request with an invalid signature" do
    payload = fixture('pull_request_event.merged.to_non_default_branch')

    options = default_options(payload)
    options[:headers]['X-Hub-Signature'] = 'ZOMG wrong signature'
    post webhooks_contributors_path, options

    assert_equal 500, response.status
    assert_match "abc-123", JSON.parse(response.body)['error']
    assert_match "invalid signature", JSON.parse(response.body)['error']
  end

  private

  def default_options(payload)
    {
      headers: {
        'X-GitHub-Delivery' => 'abc-123',
        # Signature is pre-calculated to match the post body 'fake'.
        # Under normal circumstances, the request.raw_post is the actual raw
        # post body that was received.
        'X-Hub-Signature' => 'sha1=cfbe1b6a0950b651e6f07e951476bb818051ae16',
      },
      env: {
        'action_dispatch.request.request_parameters' => payload,
        'action_dispatch.request.raw_post' => 'fake',
      }
    }
  end

  def fixture(name)
    path = '../../../fixtures/contributions/%s.json' % name
    JSON.parse(File.read(File.absolute_path(path, __FILE__)))
  end
end
