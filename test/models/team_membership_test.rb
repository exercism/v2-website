require 'test_helper'

class TeamMembershipTest < ActiveSupport::TestCase
  test "returns user name" do
    user = create(:user, name: "User")
    member = create(:team_membership, user: user)

    assert_equal "User", member.name
  end
end
