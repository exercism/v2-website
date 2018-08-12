class CreateTeamMembership
  include Mandate

  def initialize(user, team)
    @user = user
    @team = team
  end

  def call
    create_team_membership!
    delete_redundant_invites!
  end

  private

  attr_reader :user, :team

  def create_team_membership!
    TeamMembership.create!(team: team, user: user)
  end

  def delete_redundant_invites!
    team.invitations.for_user(user).destroy_all
  end
end
