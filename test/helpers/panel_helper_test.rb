require "test_helper"

class PanelHelperTest < ActionView::TestCase
  test "renders full width panel for user with setting" do
    user = build(:user, full_width_code_panes: true)

    assert_equal '<div class="panels"></div>', render_panels(user) { }
  end

  test "renders vertical split panel for user with setting" do
    user = build(:user, full_width_code_panes: false)

    assert_equal(
      '<div class="panels panels--vertical-split"></div>',
      render_panels(user) { }
    )
  end
end
