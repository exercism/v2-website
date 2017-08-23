require 'test_helper'

class Webhooks::TrackUpdatesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "create should return 200" do
    post webhooks_track_updates_path

    assert_response 200
  end

  test "create should enqueue UpdateTrackJob when pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")
    webhook["ref"] = "refs/heads/master"
    webhook["repository"]["name"] = "ruby"
    track = create(:track, slug: "ruby")

    assert_enqueued_with(job: UpdateTrackJob, args: [track]) do
      post webhooks_track_updates_path, params: webhook
    end
  end

  test "create should not enqueue UpdateTracksJob when not pushed to master" do
    webhook = load_json("test/fixtures/github/push_event.json")

    assert_no_enqueued_jobs do
      post webhooks_track_updates_path, params: webhook
    end
  end

  private

  def load_json(file)
    JSON.parse(File.read(file))
  end
end
