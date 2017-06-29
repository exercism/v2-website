class Iteration < ApplicationRecord
  belongs_to :solution
  has_many :discussion_posts

  enum mentor_status: [:pending, :reply, :refactor, :approved]
end
