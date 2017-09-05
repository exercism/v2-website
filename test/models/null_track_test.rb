require "test_helper"

class NullTrackTest < ActiveSupport::TestCase
  test "repo returns nil" do
    assert_nil NullTrack.new.repo
  end
end
