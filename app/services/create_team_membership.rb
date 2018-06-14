class CreateTeamMembership
  include Mandate

  def initialize(user, team)
    @user = user
    @team = team
  end

  def call
    TeamMembership.create!(team: team, user: user)
  end

  private
  attr_reader :user, :team
end
