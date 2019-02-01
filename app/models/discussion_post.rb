class DiscussionPost < ApplicationRecord
  belongs_to :iteration
  has_one :solution, through: :iteration

  belongs_to :team_iteration, class_name: "Iteration", optional: true
  has_one :team_solution, through: :team_iteration

  belongs_to :user, optional: true

  validates :content, presence: true

  delegate :handle, :avatar_url, to: :delegated_user

  def solution
    iteration.solution
  end

  private

  def delegated_user
    user || NullUser.new
  end
end
