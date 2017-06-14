class Iteration < ApplicationRecord
  belongs_to :solution
  has_many :discussion_posts
end
