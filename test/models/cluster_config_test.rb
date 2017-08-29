require "test_helper"

class ClusterConfigTest < ActiveSupport::TestCase
  test "gets the server identity from a file" do
    assert_equal "hostname", ClusterConfig.server_identity
  end
end
