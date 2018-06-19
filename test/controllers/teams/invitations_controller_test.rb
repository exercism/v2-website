require 'test_helper'

class Teams::InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "prevents non-admins from removing invites" do
    non_admin = create(:user)
    team = create(:team)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)
    invite = create(:team_invitation, team: team)

    sign_in!(non_admin)
    assert_raises(ActiveRecord::RecordNotFound) do
      delete teams_invitation_url(invite)
    end
  end
end
