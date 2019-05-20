class TeamSolution < ApplicationRecord
  include SolutionBase

  belongs_to :team
  belongs_to :user
  belongs_to :exercise

  has_many :iterations, as: :solution

  def self.for_team_and_user(team, user)
    where(team: team, user: user)
  end

  def self.find_by_uuid_for_team_and_user(uuid, team, user)
    for_team_and_user(team, user).where(uuid: uuid).first!
  end

  def team_solution?
    true
  end

  def use_auto_analysis?
    false
  end
end
