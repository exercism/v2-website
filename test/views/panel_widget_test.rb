require "test_helper"

class PanelWidgetTest < ActionView::TestCase
  test "renders full width panel for user with setting" do
    user = build(:user, full_width_code_panes: true)

    render "widgets/panels", user: user

    assert_select ".panels"
    assert_select ".panels.panels--vertical-split", false
  end

  test "renders vertical split panel for user with setting" do
    user = build(:user, full_width_code_panes: false)

    render "widgets/panels", user: user

    assert_select ".panels.panels--vertical-split"
  end
end
