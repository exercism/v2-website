class Iteration < ApplicationRecord
  belongs_to :solution, polymorphic: true

  # Helper methods for eager-loading
  belongs_to :team_solution, class_name: "TeamSolution", optional: true
  belongs_to :person_solution, class_name: "Solution", optional: true

  has_many :files, class_name: "IterationFile", dependent: :destroy
  has_many :discussion_posts, dependent: :destroy
  has_many :notifications, as: :about

  def discussion_post_notifications_for_user
    notifications.where(trigger_type: "DiscussionPost", user_id: solution.user_id)
  end

  def mentor_discussion_posts
    discussion_posts.where.not(user_id: solution.user_id)
  end
end
