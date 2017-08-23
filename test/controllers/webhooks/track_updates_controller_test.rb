require 'test_helper'

class Webhooks::TrackUpdatesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "create should return 200" do
    post webhooks_track_updates_path

    assert_response 200
  end

  test "create should create a TrackUpdate record when pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")
    webhook["ref"] = "refs/heads/master"
    webhook["repository"]["name"] = "ruby"
    track = create(:track, slug: "ruby")

    post webhooks_track_updates_path, params: webhook

    track_update = TrackUpdate.last
    assert_equal track, track_update.track
  end

  test "create should not create a TrackUpdate when not pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")

    post webhooks_track_updates_path, params: webhook

    assert_nil TrackUpdate.last
  end

  private

  def load_json(file)
    JSON.parse(File.read(file))
  end
end
