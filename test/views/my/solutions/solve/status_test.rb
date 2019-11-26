require "test_helper"

class StatusTest < ActionView::TestCase
  test "renders nothing when submission is nil" do
    render "my/solutions/solve/status", submission: nil

    assert_empty rendered
  end
end
