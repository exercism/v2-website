require 'test_helper'

class Git::SyncsTracksTest < ActiveSupport::TestCase
  test "syncs tracks" do
    track = create(:track)

    Git::SyncsTrack.expects(:sync!).with(track)

    Git::SyncsTracks.sync([track])
  end
end
