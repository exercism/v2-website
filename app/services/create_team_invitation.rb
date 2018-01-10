class CreateTeamInvitation
  include Mandate

  attr_reader :team, :invited_by, :email
  def initialize(team, invited_by, email)
    @team = team
    @invited_by = invited_by
    @email = email
  end

  def call
    team.invitations.create!(
      email: email,
      invited_by: invited_by
    )
    team
  end
end

