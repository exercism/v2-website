class CreateTeamMembership
  include Mandate

  initialize_with :user, :team

  def call
    create_team_membership!
    delete_redundant_invites!
  end

  private

  def create_team_membership!
    TeamMembership.create!(team: team, user: user)
  end

  def delete_redundant_invites!
    team.invitations.for_user(user).destroy_all
  end
end
