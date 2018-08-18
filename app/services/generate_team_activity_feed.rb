class GenerateTeamActivityFeed
  include Mandate

  initialize_with :team

  def call
    objs = []
    objs += team.memberships.order('created_at DESC').limit(20).to_a
    objs += team.solutions.order('created_at DESC').limit(20).to_a
    objs += Iteration.where(solution: team.solutions).order('created_at DESC').limit(20).
                      includes(team_solution: {exercise: :track}).to_a
    objs += DiscussionPost.where(iteration: Iteration.where(solution: team.solutions)).order('created_at DESC').limit(20).
                      includes(team_solution: {exercise: :track}).to_a

    objs.sort_by(&:created_at).reverse[0,20]
  end
end
