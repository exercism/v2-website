class CreateTeam
  include Mandate

  initialize_with :user, :name, :avatar

  def call
    team = Team.create!(
      name: name,
      avatar: avatar
    )
    team.memberships.create!(
      user: user,
      admin: true
    )
    team
  end
end
