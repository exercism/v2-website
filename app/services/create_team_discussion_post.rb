class CreateTeamDiscussionPost < CreatesDiscussionPost
  include Mandate

  def initialize(iteration, user, content)
    super
  end

  def call
    return false unless user_may_comment?

    create_discussion_post!
    discussion_post
  end

  def user_may_comment?
    user == solution.user ||
    user.team_memberships.where(team: solution.team).exists?
  end
end

