class CreateSolutionComment < CreatesDiscussionPost
  include Mandate

  initialize_with :solution, :commenter, :content

  def call
    @comment = SolutionComment.create!(
      solution: solution,
      user: commenter,
      content: content,
      html: html
    )

    update_solution_comments_counter
    create_solution_user_notification
    create_commenter_notifications

    return comment
  end

  private
  attr_reader :comment

  def html
    ParseMarkdown.(content)
  end

  def update_solution_comments_counter
    Solution.where(id: solution).update_all(
      "num_comments = (SELECT COUNT(*) from solution_comments where solution_id = #{solution.id})"
    )
  end


  def create_solution_user_notification
    return if solution.user == commenter

    CreateNotification.(
      solution.user,
      :new_solution_comment_for_solution_user,
      "Someone has commented on your solution to <strong>#{solution.exercise.title}</strong> on the "\
      "<strong>#{solution.exercise.track.title}</strong>.",
      Rails.application.routes.url_helpers.solution_url(solution, anchor: "comment-#{comment}"),
      trigger: comment,
      about: solution
    )

    DeliverEmail.(
      solution.user,
      :new_solution_comment_for_solution_user,
      comment
    )
  end

  def create_commenter_notifications
    users = solution.comments.map(&:user) - [commenter, solution.user]
    users.each do |user|
      CreateNotification.(
        user,
        :new_solution_comment_for_other_commenter,
        "Someone has commented on #{solution.user.handle_for(solution.exercise.track)}'s solution to <strong>#{solution.exercise.title}</strong> on the "\
        "<strong>#{solution.exercise.track.title}</strong>.",
        Rails.application.routes.url_helpers.solution_url(solution, anchor: "comment-#{comment}"),
        trigger: comment,
        about: solution
      )

      DeliverEmail.(
        user,
        :new_solution_comment_for_other_commenter,
        comment
      )
    end
  end
end

