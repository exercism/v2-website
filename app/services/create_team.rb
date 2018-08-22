class CreateTeam
  include Mandate

  initialize_with :user, :name

  def call
    team = Team.create!(name: name)
    team.memberships.create!(
      user: user,
      admin: true
    )
    team
  end
end
