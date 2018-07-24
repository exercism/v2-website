require_relative '../../test_helper'

class Git::SyncsTracksTest < ActiveSupport::TestCase
  test "updates track metadata" do
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track", active: false)

    stub_repo_cache! do
      Git::SyncsTrack.sync!(track)
    end

    assert track.active?
  end
end
