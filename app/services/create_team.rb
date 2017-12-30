class CreateTeam
  include Mandate

  attr_reader :user, :name
  def initialize(user, name)
    @user = user
    @name = name
  end

  def call
    team = Team.create!(name: name)
    team.memberships.create!(
      user: user,
      admin: true,
      pending: false
    )
    team
  end
end
