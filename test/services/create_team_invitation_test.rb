require 'test_helper'

class CreateTeamInvitationTest < ActiveSupport::TestCase
  test "creates team invitation" do
    inviter = create(:user)
    team = create(:team)

    CreateTeamInvitation.(team, inviter, "test@example.com")

    invite = TeamInvitation.last
    refute_nil invite, "Expected team invitation to be created"
    assert_equal inviter, invite.invited_by
    assert_equal "test@example.com", invite.email
    assert_equal team, invite.team
  end
end
