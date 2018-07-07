require 'test_helper'

class RendersUserWalkthroughTest < ActiveSupport::TestCase
  test "renders the walkthrough" do
    user = create(:user)
    auth_token = create(:auth_token, user: user, token: "TOKEN")

    assert_equal "Hello!", RendersUserWalkthrough.(user, "Hello!")
  end

  test "substitutes the configure command" do
    user = create(:user)
    auth_token = create(:auth_token, user: user, token: "TOKEN")

    assert_includes(
      RendersUserWalkthrough.(user, "[CONFIGURE_COMMAND]"),
      "exercism configure --token=TOKEN"
    )
  end
end
