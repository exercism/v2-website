require "test_helper"

class NullSolutionTest < ActiveSupport::TestCase
  test "repo returns nil" do
    assert_nil NullTrack.new.repo
  end
end
