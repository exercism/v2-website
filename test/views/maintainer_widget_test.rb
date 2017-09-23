require "test_helper"

class MaintainerWidgetTest < ActionView::TestCase
  test "renders banner for an alumnus" do
    maintainer = build(:maintainer, alumnus: "alumnum")

    render "widgets/maintainer", maintainer: maintainer

    assert_select ".banner", text: "Alumnum"
  end

  test "hides banner for an active maintainer" do
    maintainer = build(:maintainer, alumnus: nil)

    render "widgets/maintainer", maintainer: maintainer

    assert_select ".banner", 0
  end
end
