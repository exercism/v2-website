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
    delete teams_team_invitation_url(invite.team, invite)

    assert_redirected_to teams_team_path(team)
  end
end
