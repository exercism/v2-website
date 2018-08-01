require_relative '../../test_helper'

class Git::SyncsTracksTest < ActiveSupport::TestCase
  test "updates track metadata" do
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track", active: false)

    stub_repo_cache! do
      Git::SyncsTrack.sync!(track)
    end

    assert track.active?
  end

  test "updates exercise unlocked_by" do
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track", active: false)
    slugs = create(:exercise, track: track)
    hello_world = create(:exercise,
                         track: track,
                         unlocked_by: slugs,
                         uuid: "4e2533dd-3af5-400b-869d-78140764d533")

    stub_repo_cache! do
      Git::SyncsTrack.sync!(track)
    end

    hello_world.reload
    assert_nil hello_world.unlocked_by
  end
end
