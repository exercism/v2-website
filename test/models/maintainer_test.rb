require 'test_helper'

class MaintainerTest < ActiveSupport::TestCase
  test "returns active maintainers" do
    create_list(:maintainer, 5, alumnus: "alumnus")
    create_list(:maintainer, 6, alumnus: nil)

    assert_equal 6, Maintainer.active.count
  end

  test "active when no alumnus string" do
    maintainer = build(:maintainer, alumnus: nil)

    assert maintainer.active?
  end

  test "not active when alumnus string exists" do
    maintainer = build(:maintainer, alumnus: "alumnus")

    refute maintainer.active?
  end
end
