class DiscussionPost < ApplicationRecord
  belongs_to :iteration

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
