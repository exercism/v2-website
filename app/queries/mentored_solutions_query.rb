class MentoredSolutionsQuery
  include Mandate

  def call
    Solution.
      select(
        "solutions.*,"\
        "MIN(discussion_posts.created_at) as first_mentored_at,"\
        "(TIMESTAMPDIFF(SECOND, mentoring_requested_at, MIN(discussion_posts.created_at))) as wait_time"
      ).
      joins(:discussion_posts).
      where.not(mentoring_requested_at: nil).
      where(track_in_independent_mode: false).
      where("num_mentors > 0").
      where.not(discussion_posts: { user_id: User::SYSTEM_USER_ID }).
      group(:solution_id)
  end
end
