class DiscussionPost < ApplicationRecord
  belongs_to :iteration

  belongs_to :user

  validates :content, presence: true

  def solution
    iteration.solution
  end
end
