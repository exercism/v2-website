class CreateTeamDiscussionPost < CreatesDiscussionPost
  include Mandate

  def initialize(iteration, user, content)
    super
  end

  def call
    return false unless user_may_comment?

    create_discussion_post!
    update_solution

    discussion_post
  end

  def user_may_comment?
    user == solution.user ||
    user.team_memberships.where(team: solution.team).exists?
  end

  def update_solution
    needs_feedback, has_unseen_feedback =
      if user == solution.user
        [true, false]
      else
        [false, true]
      end

    iteration.solution.update(
      needs_feedback: needs_feedback,
      has_unseen_feedback: has_unseen_feedback
    )
  end
end

