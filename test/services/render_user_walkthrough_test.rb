require 'test_helper'

class RenderUserWalkthroughTest < ActiveSupport::TestCase
  test "renders the walkthrough" do
    user = create :user
    auth_token = create :auth_token, user: user, token: "TOKEN"

    assert_equal "Hello!", RenderUserWalkthrough.(user, "Hello!")
  end

  test "substitutes the configure command" do
    user = create :user
    token = SecureRandom.uuid
    auth_token = create :auth_token, user: user, token: token

    assert_equal(
      "exercism configure --token=#{token}",
      RenderUserWalkthrough.(user, "[CONFIGURE_COMMAND]")
    )
  end

  test "substitutes the configure command without user" do
    assert_equal(
      "exercism configure --token=[TOKEN]",
      RenderUserWalkthrough.(nil, "[CONFIGURE_COMMAND]")
    )
  end
end
