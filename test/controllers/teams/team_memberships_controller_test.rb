require 'test_helper'

class Teams::TeamMembershipsControllerTest < ActionDispatch::IntegrationTest

  test "prevents non-admins from removing team members" do
    non_admin = create(:user)
    member = create(:user)
    team = create(:team)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)
    membership = create(:team_membership,
                        user: member,
                        team: team,
                        admin: false)

    sign_in!(non_admin)
    assert_raises(ActiveRecord::RecordNotFound) do
      delete teams_team_membership_url(membership)
    end

    team.reload
    assert_includes team.members, member
  end
end
